#!/usr/bin/env bash
set -euo pipefail

# Deploy OpenTelemetry Demo to a DOKS cluster using Helm CLI.
#
# Usage:
#   ./scripts/deploy-otel-demo.sh
#   ./scripts/deploy-otel-demo.sh --cluster otel-do-dev
#   ./scripts/deploy-otel-demo.sh --cluster otel-do-dev --namespace otel-demo --release my-otel-demo
#
# Assumptions:
# - You're authenticated to DigitalOcean via doctl OR have DIGITALOCEAN_TOKEN exported.
# - You have kubectl and helm installed locally.
# - You ran `tofu apply` in environments/do/dev (or pass --cluster explicitly).

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_DIR="${REPO_ROOT}/environments/do/dev"

NAMESPACE="otel-demo"
RELEASE="my-otel-demo"
CLUSTER_NAME=""
CHART_REPO="https://open-telemetry.github.io/opentelemetry-helm-charts"
CHART_NAME="opentelemetry-demo"
CHART_VERSION=""  # optional pin (e.g., "0.39.0")
WAIT_SECONDS=600

usage() {
  cat <<EOF
Usage: $0 [--cluster NAME] [--namespace NS] [--release NAME] [--chart-version VER] [--wait-seconds N]

Options:
  --cluster        DOKS cluster name. If omitted, tries: tofu output -raw cluster_name (from ${ENV_DIR})
  --namespace      Kubernetes namespace (default: ${NAMESPACE})
  --release        Helm release name (default: ${RELEASE})
  --chart-version  Pin chart version (optional)
  --wait-seconds   Wait for LoadBalancer address (default: ${WAIT_SECONDS})
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cluster)       CLUSTER_NAME="${2:-}"; shift 2 ;;
    --namespace)     NAMESPACE="${2:-}"; shift 2 ;;
    --release)       RELEASE="${2:-}"; shift 2 ;;
    --chart-version) CHART_VERSION="${2:-}"; shift 2 ;;
    --wait-seconds)  WAIT_SECONDS="${2:-}"; shift 2 ;;
    -h|--help)       usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "ERROR: missing required command: $1" >&2; exit 1; }
}

need_cmd doctl
need_cmd kubectl
need_cmd helm

# Resolve cluster name from tofu outputs if not provided
if [[ -z "${CLUSTER_NAME}" ]]; then
  if [[ -d "${ENV_DIR}" ]]; then
    pushd "${ENV_DIR}" >/dev/null
    if tofu output -raw cluster_name >/dev/null 2>&1; then
      CLUSTER_NAME="$(tofu output -raw cluster_name)"
    fi
    popd >/dev/null
  fi
fi

if [[ -z "${CLUSTER_NAME}" ]]; then
  echo "ERROR: could not determine cluster name." >&2
  echo "Pass --cluster NAME or run from a repo with tofu outputs in ${ENV_DIR}." >&2
  exit 1
fi

echo "==> Using cluster: ${CLUSTER_NAME}"
echo "==> Using namespace: ${NAMESPACE}"
echo "==> Using release: ${RELEASE}"

# Ensure doctl is authenticated
if ! doctl account get >/dev/null 2>&1; then
  if [[ -n "${DIGITALOCEAN_TOKEN:-}" ]]; then
    echo "==> Authenticating doctl using DIGITALOCEAN_TOKEN"
    doctl auth init -t "${DIGITALOCEAN_TOKEN}" >/dev/null
  else
    echo "ERROR: doctl is not authenticated. Run: doctl auth init (or export DIGITALOCEAN_TOKEN)." >&2
    exit 1
  fi
fi

echo "==> Saving kubeconfig for cluster"
doctl kubernetes cluster kubeconfig save "${CLUSTER_NAME}" >/dev/null

echo "==> Verifying cluster connectivity"
kubectl get nodes >/dev/null

# Create a temporary values file to avoid Helm --set escaping issues with hyphenated keys.
VALUES_FILE="$(mktemp)"
trap 'rm -f "${VALUES_FILE}"' EXIT

cat > "${VALUES_FILE}" <<EOF
components:
  frontend-proxy:
    service:
      type: LoadBalancer
  flagd:
    env:
      - name: GOMEMLIMIT
        value: 512MiB
    useDefault:
      env: true
    resources:
      limits:
        memory: 768Mi
      requests:
        memory: 256Mi
    sidecarContainers:
      - name: flagd-ui
        useDefault:
          env: true
        resources:
          limits:
            memory: 3Gi
          requests:
            memory: 512Mi
EOF

echo "==> Adding/updating Helm repo"
helm repo add opentelemetry "${CHART_REPO}" >/dev/null 2>&1 || true
helm repo update >/dev/null

echo "==> Installing/upgrading OTel demo chart"
HELM_ARGS=(
  upgrade --install "${RELEASE}" "opentelemetry/${CHART_NAME}"
  --namespace "${NAMESPACE}"
  --create-namespace
  -f "${VALUES_FILE}"
)

if [[ -n "${CHART_VERSION}" ]]; then
  HELM_ARGS+=(--version "${CHART_VERSION}")
fi

# We don't rely on Helm provider semantics here; Helm CLI will wait if you choose.
# Keeping this relatively short because the demo can take a bit to settle.
HELM_ARGS+=(--wait --timeout 10m)

helm "${HELM_ARGS[@]}"

echo "==> Waiting for LoadBalancer address (up to ${WAIT_SECONDS}s)"
SVC="${RELEASE}-frontendproxy"

# Note: service name can vary slightly by chart version; fallback to label query if needed.
if ! kubectl -n "${NAMESPACE}" get svc "${SVC}" >/dev/null 2>&1; then
  echo "==> Service ${SVC} not found, searching for frontend proxy service by label..."
  SVC="$(kubectl -n "${NAMESPACE}" get svc -l 'app.kubernetes.io/instance='"${RELEASE}" -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | grep -i 'frontend' | head -n1 || true)"
fi

if [[ -z "${SVC}" ]]; then
  echo "ERROR: could not find a frontend service to extract a LoadBalancer address." >&2
  kubectl -n "${NAMESPACE}" get svc >&2 || true
  exit 1
fi

deadline=$(( $(date +%s) + WAIT_SECONDS ))
addr=""

while [[ $(date +%s) -lt ${deadline} ]]; do
  addr="$(kubectl -n "${NAMESPACE}" get svc "${SVC}" -o jsonpath='{.status.loadBalancer.ingress[0].ip}{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)"
  if [[ -n "${addr}" ]]; then
    break
  fi
  sleep 5
done

if [[ -z "${addr}" ]]; then
  echo "ERROR: LoadBalancer address not ready in time." >&2
  kubectl -n "${NAMESPACE}" get svc "${SVC}" -o yaml >&2 || true
  exit 1
fi

echo
echo "✅ OTel demo deployed."
echo "Frontend URL (usually): http://${addr}:8080/"
echo
echo "Next:"
echo "  - Generate traffic: curl -fsS http://${addr}:8080/ >/dev/null"
echo "  - View pods:        kubectl -n ${NAMESPACE} get pods"
