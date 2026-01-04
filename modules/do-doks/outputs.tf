output "cluster_id" { value = digitalocean_kubernetes_cluster.this.id }
output "name" { value = digitalocean_kubernetes_cluster.this.name }

# The DO provider exports kubeconfig details as attributes on the cluster resource. :contentReference[oaicite:1]{index=1}
output "kube_host" {
  value = digitalocean_kubernetes_cluster.this.kube_config[0].host
}
output "kube_token" {
  value     = digitalocean_kubernetes_cluster.this.kube_config[0].token
  sensitive = true
}
output "kube_ca_cert" {
  value     = digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  sensitive = true
}
