output "cluster_name" { value = module.doks.name }

output "otel_namespace" {
  value = helm_release.otel_demo.namespace
}
