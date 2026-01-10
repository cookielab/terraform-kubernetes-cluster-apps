variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Number of Grafana Alloy replicas"
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
  })
  default     = {}
  description = "Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API."

  validation {
    condition     = contains(["mimir", "prometheus"], var.metrics.backend_type)
    error_message = "Valid values for metrics.backend_type are \"mimir\" or \"prometheus\"."
  }
}

variable "loki" {
  type = object({
    url                    = optional(string, "http://loki:3100")
    tenant_id              = optional(string, "default")
    username               = optional(string, "admin")
    password               = optional(string, "admin")
    scrape_pods_global     = optional(bool, true)
    scrape_pods_annotation = optional(string, "loki.logs.enabled")
    scrape_logs_method     = optional(string, "api")
  })
  default     = {}
  description = "Grafana Alloy scrape settings for Loki logs"

  validation {
    condition     = contains(["file", "api"], var.loki.scrape_logs_method)
    error_message = "Valid values for loki.scrape_logs_method are \"file\" or \"api\"."
  }
}

variable "aws" {
  type = object({
    account = optional(string, "")
    region  = optional(string, "")
  })
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

variable "stability_level" {
  type        = string
  default     = "generally-available"
  description = "Stability level for the Grafana Alloy"
}

variable "live_debug" {
  type        = bool
  default     = false
  description = "Enable live debug for the Grafana Alloy"
}

variable "clustering_enabled" {
  type        = bool
  default     = false
  description = "Enable clustering for the Grafana Alloy"
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
