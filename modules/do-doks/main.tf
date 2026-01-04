resource "digitalocean_kubernetes_cluster" "this" {
  name    = var.name
  region  = var.region
  version = var.k8s_version

  node_pool {
    name       = "default"
    size       = var.node_size
    node_count = var.node_count
  }
}
