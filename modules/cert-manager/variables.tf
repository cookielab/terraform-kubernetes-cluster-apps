variable "namespace" {
  description = "value of the namespace to deploy the cert manager"
  type        = string
  default     = "cluster-apps"
}

variable "cert_manager_version" {
  description = "cert-manager version (chart and CRDs) overriding the module default, to upgrade one minor version at a time - cert-manager does not support skipping minor versions"
  type        = string
  default     = null

  validation {
    condition     = var.cert_manager_version == null || can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.cert_manager_version))
    error_message = "cert_manager.version must be a release tag including the \"v\" prefix, e.g. \"v1.21.3\"."
  }
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

variable "cert_manager_resources" {
  description = "container resources for the cert-manager controller"
  type = object({
    replicas = optional(number, 1)
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

variable "cainjector_resources" {
  description = "container resources for the cert-manager cainjector"
  type = object({
    replicas = optional(number, 1)
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

variable "webhook_resources" {
  description = "container resources for the cert-manager webhook"
  type = object({
    replicas = optional(number, 1)
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
