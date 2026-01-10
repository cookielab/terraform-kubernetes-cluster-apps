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
    ssl_enabled  = optional(bool, true)
  })
  default     = {}
  description = "Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API."

  validation {
    condition     = contains(["mimir", "prometheus"], var.metrics.backend_type)
    error_message = "Valid values for metrics.backend_type are \"mimir\" or \"prometheus\"."
  }
}

variable "k8s_pods" {
  type = object({
    scrape_interval        = optional(string, "1m")
    scrape_timeout         = optional(string, "30s")
    scrape_pods_global     = optional(bool, false)
    scrape_pods_annotation = optional(string, "prometheus_io_scrape")
  })
  default     = {}
  description = "Grafana Alloy scrape timings for K8S pods"
}

variable "k8s_services" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
  })
  default     = {}
  description = "Grafana Alloy scrape timings for K8S services"
}

variable "k8s_cadvisor" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
  })
  default     = {}
  description = "Grafana Alloy scrape timings for K8S cadvisor"
}

variable "k8s_kubelet" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
  })
  default     = {}
  description = "Grafana Alloy scrape timings for K8S kubelet"
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
