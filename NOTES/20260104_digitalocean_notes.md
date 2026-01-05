# Notes from 20260104

Got a ton of errors at the end of the DOKS run trying to bring in the opentofu helm chart, saving this for later (next time I ought to capture stderr by default. got excited and didn't think about that):

```txt
┌─[drew@jac494-primary] - [~/Projects/otel-multicloud-playground/environments/do/dev] - [1471]
└─[$] tofu apply -var "do_token=$DIGITALOCEAN_TOKEN"                                                                [12:01:35]

OpenTofu used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

OpenTofu will perform the following actions:

  # helm_release.otel_demo will be created
  + resource "helm_release" "otel_demo" {
      + chart            = "opentelemetry-demo"
      + create_namespace = true
      + name             = "my-otel-demo"
      + namespace        = "otel-demo"
      + repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
      + set_wo           = (write-only attribute)
      + values           = [
          + <<-EOT
                "components":
                  "frontend-proxy":
                    "service":
                      "type": "LoadBalancer"
            EOT,
        ]
    }

  # module.doks.digitalocean_kubernetes_cluster.this will be created
  + resource "digitalocean_kubernetes_cluster" "this" {
      + cluster_subnet                   = (known after apply)
      + created_at                       = (known after apply)
      + destroy_all_associated_resources = false
      + endpoint                         = (known after apply)
      + ha                               = false
      + id                               = (known after apply)
      + ipv4_address                     = (known after apply)
      + kube_config                      = (sensitive value)
      + name                             = "otel-do-dev"
      + region                           = "nyc3"
      + registry_integration             = false
      + service_subnet                   = (known after apply)
      + status                           = (known after apply)
      + surge_upgrade                    = true
      + updated_at                       = (known after apply)
      + urn                              = (known after apply)
      + version                          = "1.34"
      + vpc_uuid                         = (known after apply)

      + amd_gpu_device_metrics_exporter_plugin (known after apply)

      + amd_gpu_device_plugin (known after apply)

      + control_plane_firewall (known after apply)

      + maintenance_policy (known after apply)

      + node_pool {
          + actual_node_count = (known after apply)
          + auto_scale        = false
          + id                = (known after apply)
          + name              = "default"
          + node_count        = 2
          + nodes             = (known after apply)
          + size              = "s-2vcpu-4gb"
        }

      + nvidia_gpu_device_plugin (known after apply)

      + rdma_shared_device_plugin (known after apply)

      + routing_agent (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  OpenTofu will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.doks.digitalocean_kubernetes_cluster.this: Creating...
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [10s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [20s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [30s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [40s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [50s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [1m0s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [1m10s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [1m20s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [1m30s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [1m40s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [1m50s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [2m0s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [2m10s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [2m20s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [2m30s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [2m40s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [2m50s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [3m0s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [3m10s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [3m20s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [3m30s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [3m40s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [3m50s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [4m0s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [4m10s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [4m20s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Still creating... [4m30s elapsed]
module.doks.digitalocean_kubernetes_cluster.this: Creation complete after 4m36s [id=ff573cd7-7719-417c-af96-5d69b9516335]
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .status: was null, but now
│ cty.StringVal("deployed").
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .wait: was null, but now cty.True.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .atomic: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .reset_values: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .dependency_update: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .lint: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .skip_crds: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .verify: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .wait_for_jobs: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .pass_credentials: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .take_ownership: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .timeout: was null, but now cty.NumberIntVal(300).
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .force_update: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .recreate_pods: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .disable_webhooks: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .id: was null, but now cty.UnknownVal(cty.String).
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .metadata: was null, but now
│ cty.UnknownVal(cty.Object(map[string]cty.Type{"app_version":cty.String, "chart":cty.String, "first_deployed":cty.Number,
│ "last_deployed":cty.Number, "name":cty.String, "namespace":cty.String, "notes":cty.String, "revision":cty.Number,
│ "values":cty.String, "version":cty.String})).
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .replace: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .reuse_values: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .disable_crd_hooks: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .upgrade_install: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .cleanup_on_fail: was null, but now cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .disable_openapi_validation: was null, but now
│ cty.False.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .max_history: was null, but now
│ cty.NumberIntVal(0).
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .render_subchart_notes: was null, but now cty.True.
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
╷
│ Error: Provider produced inconsistent final plan
│
│ When expanding the plan for helm_release.otel_demo to include new values learned so far during apply, provider
│ "registry.opentofu.org/hashicorp/helm" produced an invalid new value for .version: was null, but now
│ cty.StringVal("0.39.0").
│
│ This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
┌─[drew@jac494-primary] - [~/Projects/otel-multicloud-playground/environments/do/dev] - [1471]
└─[$]
```

So it seems like fixing all these is probably just going to be best to make them explicit:

```sh
┌─[drew@jac494-primary] - [~/Projects/otel-multicloud-playground/environments/do/dev] - [1525]
└─[$] grep "cty\." NOTES/20260104_digitalocean_notes.md | cut -d " " -f9,14                                         [13:04:32]

.wait: cty.True.
.atomic: cty.False.
.reset_values: cty.False.
.dependency_update: cty.False.
.lint: cty.False.
.skip_crds: cty.False.
.verify: cty.False.
.wait_for_jobs: cty.False.
.pass_credentials: cty.False.
.take_ownership: cty.False.
.timeout: cty.NumberIntVal(300).
.force_update: cty.False.
.recreate_pods: cty.False.
.disable_webhooks: cty.False.
.id: cty.UnknownVal(cty.String).



.replace: cty.False.
.reuse_values: cty.False.
.disable_crd_hooks: cty.False.
.upgrade_install: cty.False.
.cleanup_on_fail: cty.False.


.render_subchart_notes: cty.True.
```
