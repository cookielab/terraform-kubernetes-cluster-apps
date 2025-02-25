variable "namespace" {
  description = "Namespace where Keda will be deployed"
  type        = string
  default     = "cluster-apps"
}

variable "repository" {
  description = "Helm repository URL for Keda"
  type        = string
  default     = "https://kedacore.github.io/charts"
}

variable "replicas" {
  description = "Number of replicas for Keda operator"
  type        = number
  default     = 2
}

variable "log_level" {
  description = "Logging level for Keda operator"
  type        = string
  default     = "info"
}

variable "metrics_server" {
  description = "Enable Keda's Prometheus metrics adapter"
  type        = bool
  default     = true
}

variable "node_selector" {
  description = "Node selector for Keda pods"
  type        = map(string)
  default     = {}
}

variable "tolerations" {
  description = "Tolerations for Keda pods"
  type = list(object({
    key      = string
    operator = string
    value    = optional(string, null)
    effect   = optional(string, null)
  }))
  default = []
}

variable "pod_annotations" {
  description = "Annotations for Keda pods"
  type        = map(string)
  default     = {}
}

variable "role_arn" {
  description = "IAM Role for Keda ServiceAccount"
  type        = string
  nullable    = true
}
