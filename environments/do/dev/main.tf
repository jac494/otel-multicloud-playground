module "doks" {
  source      = "../../../modules/do-doks"
  name        = "otel-do-dev"
  region      = var.region
  k8s_version = var.k8s_version
  node_size   = var.node_size
  node_count  = var.node_count
}

resource "helm_release" "otel_demo" {
  name             = "my-otel-demo"
  namespace        = "otel-demo"
  create_namespace = true

  # Per OTel docs, repo is open-telemetry and chart is opentelemetry-demo. :contentReference[oaicite:4]{index=4}
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-demo"

  wait    = true
  timeout = 900

  # Make the frontend reachable without port-forward:
  values = [yamlencode({
    components = {
      frontend-proxy = {
        service = { type = "LoadBalancer" }
      }
    }
  })]

  # Ensure cluster exists before Helm tries to talk to it
  depends_on = [module.doks]
}
