variable "namespace" {
  description = "value of the namespace to deploy the cert manager"
  type        = string
  default     = "cluster-apps"
}

variable "node_selector" {
  description = "node selector to deploy the cert manager"
  type        = map(string)
  default = {
    "node.kubernetes.io/pool" = "critical"
  }
}

variable "tolerations" {
  description = "tolerations to deploy the cert manager"
  type = list(object({
    key      = string
    operator = string
    value    = optional(string, null)
    effect   = optional(string, null)
  }))
  default = []
}
