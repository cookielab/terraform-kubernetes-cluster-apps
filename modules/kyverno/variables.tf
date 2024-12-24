variable "namespace" {
  description = "value of the namespace to deploy the kyverno"
  type        = string
  default     = "cluster-apps"
}

variable "registry" {
  description = "registry of immage to deploy the kyverno"
  type        = string
  default     = "ghcr.io"
}

variable "docker_hub_registry" {
  description = "docker hub registry to deploy the kyverno"
  type        = string
  default     = "docker.io"
}

variable "node_selector" {
  description = "node selector to deploy the kyverno"
  type        = map(string)
  default = {
    "node.kubernetes.io/pool" = "critical"
  }
}

variable "tolerations" {
  description = "tolerations to deploy the kyverno"
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

variable "admission_controller" {
  type = object({
    replicas = optional(number, 2)
    container = optional(object(
      {
        resources = object({
          requests = object({
            cpu    = optional(string, "300m")
            memory = optional(string, "384Mi")
          }),
          limits = object({
            memory = optional(string, "384Mi")
          })
        })
      }
      ),
      {
        resources = {
          requests = {
            cpu    = "300m"
            memory = "384Mi"
          }
          limits = {
            memory = "384Mi"
          }
        }
      }
    )
  })
  default = {
    replicas = 2
    container = {
      resources = {
        requests = {
          cpu    = "300m"
          memory = "384Mi"
        }
        limits = {
          memory = "384Mi"
        }
      }
    }
  }
}
