variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
}

variable "config" {
  type        = list(string)
  default     = []
  description = "Grafana Alloy River config snippets"
}

variable "agent_resources" {
  type = object({
    requests = optional(object({
      cpu    = optional(string, "500m")
      memory = optional(string, "512Mi")
    }), {})
    limits = optional(object({
      cpu    = optional(string, null)
      memory = optional(string, null)
    }), {})
  })
  default     = {}
  description = "Resources for the Grafana OTel agent"
}

variable "controller_resources" {
  type = object({
    requests = optional(object({
      cpu    = optional(string, "1m")
      memory = optional(string, "5Mi")
    }), {})
    limits = optional(object({
      cpu    = optional(string, "100m")
      memory = optional(string, "50Mi")
    }), {})
  })
  default     = {}
  description = "Resources for the Grafana Alloy controller"
}

variable "chart_version" {
  type        = string
  description = "Helm chart version of Grafana Alloy"
  default     = "1.0.2"
}

variable "image" {
  type = object({
    registry   = optional(string, "docker.io")
    repository = optional(string, "grafana/alloy")
  })
  default     = {}
  description = "Image registry for Grafana Alloy"
}

variable "metrics" {
  type = object({
    endpoint     = optional(string, "http://mimir:9090")
    tenant       = optional(string, "default")
    backend_type = optional(string, "mimir")
    ssl_enabled  = optional(bool, true)
  })
  default     = {}
  description = "Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API. Mimir and Promethes backends are supported."

  validation {
    condition     = contains(["mimir", "prometheus"], var.metrics.backend_type)
    error_message = "Valid values for metrics.backend_type are \"mimir\" or \"prometheus\"."
  }
}

variable "k8s_mimir_rules" {
  type = object({
    enabled          = optional(bool, false)
    sync_interval    = optional(string, "5m")
    namespace_prefix = optional(string, "")
  })
  default     = {}
  description = "Grafana Alloy Mimir rules configuration"
}

variable "otel" {
  type = object({
    enabled   = optional(bool, false)
    http_port = optional(number, 4318)
    grpc_port = optional(number, 4317)
    endpoint  = optional(string, "http://tempo:4318")
  })
  default     = {}
  description = "Grafana Alloy OTel configuration. NOTE: There can be only one OTel receiver at the moment."
}

variable "rule_match_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to match rules"
}

variable "tenant_distinguisher" {
  type        = string
  default     = ""
  description = "Distinguisher for the tenant"
}

variable "tolerations" {
  type = list(object({
    key      = string
    operator = string
    value    = optional(string)
    effect   = string
  }))
  default     = []
  description = "Tolerations for the Grafana Alloy"
}

variable "node_selector" {
  type        = map(string)
  default     = {}
  description = "Node selector for the Grafana Alloy"
}

variable "pod_disruption_budget" {
  type = object({
    enabled         = optional(bool)
    min_available   = optional(number)
    max_unavailable = optional(number)
  })
  default = {
    enabled         = true
    min_available   = 1
    max_unavailable = null
  }
  description = "Grafana Alloy pod disruption budget configuration"
}
