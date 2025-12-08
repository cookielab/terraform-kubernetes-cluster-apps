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

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "This role is for assuming by cloudwatch exporter"
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

variable "aws_alb" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape aws ALB metrics"
}

variable "aws_rds" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape aws RDS metrics"
}

variable "aws_mq" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape aws MQ metrics"
}

variable "aws_sqs" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape aws SQS metrics"
}

variable "aws_opensearch" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
  })
  default     = {}
  description = "Grafana Alloy scrape aws opensearch cloudwatch metrics"
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
