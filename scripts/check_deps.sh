#!/bin/bash
set -euo pipefail

# Simple dependency checker for local dev workflows.
# Exits non-zero if any required tool is missing.

REQ=(tofu kubectl doctl jq curl helm)
OPT=(pre-commit tflint git)

missing=()

check() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing+=("$cmd")
  fi
}

for c in "${REQ[@]}"; do check "$c"; done
for c in "${OPT[@]}"; do check "$c"; done

if [[ ${#missing[@]} -gt 0 ]]; then
  echo "Missing tools:" >&2
  for m in "${missing[@]}"; do
    echo "  - $m" >&2
  done
  echo >&2
  echo "Required for core flow: ${REQ[*]}" >&2
  echo "Optional (quality/dev): ${OPT[*]}" >&2
  echo >&2
  echo "Notes:" >&2
  echo "  - pre-commit and tflint are needed for commits/CI hygiene." >&2
  echo "  - doctl requires auth (DIGITALOCEAN_TOKEN or doctl auth init)." >&2
  exit 1
fi

echo "All required tools found."
echo
echo "Versions:"
tofu version | head -n 1 || true
kubectl version --client=true --short 2>/dev/null || kubectl version --client=true 2>/dev/null || true
helm version --short 2>/dev/null || helm version 2>/dev/null || true
doctl version 2>/dev/null || true
jq --version 2>/dev/null || true
curl --version | head -n 1 || true
pre-commit --version 2>/dev/null || true
tflint --version 2>/dev/null || true
