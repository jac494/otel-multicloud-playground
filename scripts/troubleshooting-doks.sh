#!/bin/bash

echo "#### get kubectl context"
kubectl config current-context
echo ""

echo "#### get nodes"
kubectl get nodes -o wide
echo ""

echo "#### quick helm status"
helm -n otel-demo list
helm -n otel-demo status my-otel-demo || true
helm -n otel-demo get manifest my-otel-demo | head -n 40 || true
echo ""

echo "#### what exists"
kubectl -n otel-demo get all
kubectl -n otel-demo get pods -o wide
echo ""

echo "#### recent events"
kubectl -n otel-demo get events --sort-by=.lastTimestamp | tail -n 50
echo ""
