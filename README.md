# OpenTelemetry OpenTofu Multicloud Playground

- DigitalOcean
  - ![DOKS Cluster Tofu Tests](https://img.shields.io/badge/DOKS_Cluster_Tofu_Tests-passing-green)
  - ![DOKS OTEL Services Smoke Tests](https://img.shields.io/badge/DOKS_OTEL_Services_Smoke_Tests-passing-green)
- AWS
  - ![EKS Cluster Tofu Tests](https://img.shields.io/badge/DOKS_Cluster_Tofu_Tests-tbd-grey)
  - ![EKS OTEL Services Smoke Tests](https://img.shields.io/badge/DOKS_OTEL_Services_Smoke_Tests-tbd-grey)

[OpenTelemetry Demo Docs](https://opentelemetry.io/docs/platforms/kubernetes/helm/demo/)

I wanted to have a place to check out both otel and different cloud providers' managed k8s. I also needed a project to chew on for a sec. Here we are!

First step is getting digitalocean hooked up for the initial proof of concept and to just get one use case hammered out. Doing AWS second because AWS resources are always first-class in my head for cloud providers and this is an opportunity for me to decouple that a tiny bit and to be real honest I've wanted an excuse to play with [DOKS](https://docs.digitalocean.com/products/kubernetes/) for a minute.

Prereqs (I have [some personal Ansible roles](https://github.com/jac494/blinkingboxes_home_ansible/blob/main/roles/drew_user/defaults/main.yml#L8-L15) that loosely get some of this going. I might come back and improve this but for now I don't want to distract myself from the current goal):

- `tofu`
- `kubectl`
- `doctl`
- `jq`
- `curl`
- `pre-commit`
- `tflint`

For Digital Ocean and local testing, [you'll need a personal access token](https://docs.digitalocean.com/reference/api/create-personal-access-token/) and then export it like so:

```sh
export DIGITALOCEAN_TOKEN="dop_v1_..."
```

Then run it:

```sh
cd environments/do/dev

tofu init
tofu apply -var "do_token=$DIGITALOCEAN_TOKEN"
```

Grab kubeconfig

```sh
doctl auth init -t "$DIGITALOCEAN_TOKEN"
doctl kubernetes cluster kubeconfig save otel-do-dev
```

Smoke test:

```sh
./../../..//scripts/smoke-test.sh
```

Destroy:

```sh
tofu destroy -var "do_token=$DIGITALOCEAN_TOKEN"
```
