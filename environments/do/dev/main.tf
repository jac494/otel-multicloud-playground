module "doks" {
  source      = "../../../modules/do-doks"
  name        = "otel-do-dev"
  region      = var.region
  k8s_version = var.k8s_version
  node_size   = var.node_size
  node_count  = var.node_count
}
