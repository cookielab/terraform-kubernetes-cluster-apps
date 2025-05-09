variable "namespace" {
  description = "value of the namespace to deploy the metrics-server"
  type        = string
  default     = "cluster-apps"
}

variable "repository" {
  description = "repository of immage to deploy the metrics-server"
  type        = string
  default     = "registry.k8s.io/metrics-server/metrics-server"
}

variable "node_selector" {
  description = "node selector to deploy the metrics-server"
  type        = map(string)
  default = {
    "node.kubernetes.io/pool" = "critical"
  }
}

variable "tolerations" {
  description = "tolerations to deploy the metrics-server"
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
