variable "do_token" {
  type      = string
  sensitive = true
}

variable "region" {
  type    = string
  default = "nyc3"
}

# ref https://docs.digitalocean.com/products/kubernetes/details/supported-releases/
variable "k8s_version" {
  type    = string
  default = "1.34"
}

# Cost guardrails: start small-ish but big enough to run the demo.
# The demo wants ~6GB free RAM per docs; 2 nodes of 4GB is a safe starting point. :contentReference[oaicite:3]{index=3}
variable "node_size" {
  type    = string
  default = "s-4vcpu-8gb"
}

variable "node_count" {
  type    = number
  default = 2
}
