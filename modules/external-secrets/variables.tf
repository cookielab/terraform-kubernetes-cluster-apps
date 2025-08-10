variable "namespace" {
  description = "value of the namespace to deploy the external-secrets"
  type        = string
  default     = "cluster-apps"
}

variable "repository" {
  description = "repository of immage to deploy the external-secrets"
  type        = string
  default     = "oci.external-secrets.io/external-secrets/external-secrets"
}

variable "node_selector" {
  description = "node selector to deploy the external-secrets"
  type        = map(string)
  default = {
    "node.kubernetes.io/pool" = "critical"
  }
}

variable "tolerations" {
  description = "tolerations to deploy the external-secrets"
  type = list(object({
    key      = string
    operator = string
    value    = optional(string, null)
    effect   = optional(string, null)
  }))
  default = [{
    key      = "CriticalAddonsOnly"
    operator = "Exists"
  }]
}

variable "resources" {
  description = "container resources for the External Secrets controller"
  type = object({
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }), {})
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }), {})
  })
  default = {}
}
