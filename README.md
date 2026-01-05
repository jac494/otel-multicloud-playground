# OpenTelemetry OpenTofu Playground

- DigitalOcean
  - ![DOKS Cluster Tofu Tests](https://img.shields.io/badge/DOKS_Cluster_Tofu_Tests-passing-green)
  - ![DOKS OTEL Services Smoke Tests](https://img.shields.io/badge/DOKS_OTEL_Services_Smoke_Tests-passing-green)
- AWS
  - ![EKS Cluster Tofu Tests](https://img.shields.io/badge/EKS_Cluster_Tofu_Tests-tbd-grey)
  - ![EKS OTEL Services Smoke Tests](https://img.shields.io/badge/EKS_OTEL_Services_Smoke_Tests-tbd-grey)

[OpenTelemetry Demo Docs](https://opentelemetry.io/docs/platforms/kubernetes/helm/demo/)

I wanted to have a place to check out both otel and different cloud providers' managed k8s. I also needed a project to chew on for a sec. Here we are!

Update! DOKS is able to come up, and make is also working to get the chart for the otel-demo installed.

**[Set up the DigitalOcean pat token as instructed below](#digitalocean-pat-token)** and this `make` one-liner should get it all running and run smoke tests:

```sh
make check do-up do-deploy do-test
```

First step is getting digitalocean hooked up for the initial proof of concept and to just get one use case hammered out. Doing AWS second because AWS resources are always first-class in my head for cloud providers and this is an opportunity for me to decouple that a tiny bit and to be real honest I've wanted an excuse to play with [DOKS](https://docs.digitalocean.com/products/kubernetes/) for a minute.

Prereqs (I have [some personal Ansible roles](https://github.com/jac494/blinkingboxes_home_ansible/blob/main/roles/drew_user/defaults/main.yml#L8-L15) that loosely get some of this going. I might come back and improve this but for now I don't want to distract myself from the current goal):

- `tofu`
- `kubectl`
- `doctl`
- `jq`
- `curl`
- `pre-commit`
- `tflint`

I'm getting some checks wrapped in make and in a bit I might take the time to get the developer environment a little more solid and repeatable but for now it's a workable, documented house of cards that isn't too bad to jump through but certainly under the bar that I want for this demo of what I would consider some of the base requirements for a somewhat solid Infra repo. And we haven't even covered abstracting the interface for tf for AWS or setting up github actions or other deployment. Trying to get the 'multicloud' part true and then quickly add TLS and ingress then go back and see if I can polish up the inner loop, but right now I really am real-world inner-loop-solo-maxxing for this speedrun (it's a speedrun to me, I sit in meetings all day and I need some hands-on admin slapping in the face before I claim to be any good in front of a keyboard). gitignore could use some extra work, the ADRs in docs are unsustainable currently, and I still haven't even tried to get committizen checked in either. This is super super fun. I've needed this for a while :)

## DigitalOcean PAT Token

For Digital Ocean and local testing, [you'll need a personal access token](https://docs.digitalocean.com/reference/api/create-personal-access-token/) and then export it like so:

```sh
export DIGITALOCEAN_TOKEN="dop_v1_..."
```
