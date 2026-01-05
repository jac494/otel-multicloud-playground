#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${1:-otel-demo}"
RELEASE="${2:-my-otel-demo}"

helm uninstall "${RELEASE}" -n "${NAMESPACE}" || true
kubectl delete ns "${NAMESPACE}" --ignore-not-found
