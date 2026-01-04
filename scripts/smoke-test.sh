#!/usr/bin/env bash
set -euo pipefail

NS="default"
SVC="my-otel-demo-frontendproxy"

echo "[1/4] Waiting for LoadBalancer external IP/hostname..."
for _ in {1..60}; do
  host=$(kubectl -n "$NS" get svc "$SVC" -o json | jq -r '.status.loadBalancer.ingress[0].ip // .status.loadBalancer.ingress[0].hostname // empty')
  if [[ -n "${host}" ]]; then
    break
  fi
  sleep 10
done

if [[ -z "${host:-}" ]]; then
  echo "ERROR: LoadBalancer address not ready after 10 minutes."
  exit 1
fi

url="http://${host}:8080/"
echo "[2/4] Frontend URL: $url"

echo "[3/4] Generating traffic..."
for _ in {1..20}; do
  curl -fsS "$url" >/dev/null || true
  sleep 0.5
done

echo "[4/4] Sanity check: page fetch..."
curl -fsS "$url" | head -n 5

echo "OK: endpoint reachable and traffic generated."
