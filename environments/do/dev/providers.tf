provider "digitalocean" {
  token = var.do_token
}

# Helm (and Kubernetes) providers share this configuration shape. :contentReference[oaicite:2]{index=2}
provider "helm" {
  kubernetes = {
    host                   = module.doks.kube_host
    token                  = module.doks.kube_token
    cluster_ca_certificate = base64decode(module.doks.kube_ca_cert)
  }
}
