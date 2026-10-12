variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "agent_name" {
  type        = string
  default     = "otel-collector"
  description = "Name suffix of the Grafana Alloy release. The final Helm release name will be grafana-alloy-{agent_name}."
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
    bearer_token = optional(string, null)
    username     = optional(string, null)
    password     = optional(string, null)
  })
  default     = {}
  description = "Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API. Mimir and Promethes backends are supported."

  validation {
    condition     = contains(["mimir", "prometheus"], var.metrics.backend_type)
    error_message = "Valid values for metrics.backend_type are \"mimir\" or \"prometheus\"."
  }
}

variable "kafka_jmx_metrics" {
  type = object({
    scrape_interval       = optional(string, "1m")
    scrape_timeout        = optional(string, "30s")
    scrape_period         = optional(string, "1m")
    kafka_broker_list     = optional(list(string), [])
    distinguisher         = optional(string, "default")
    metrics_endpoint_path = optional(string, "/metrics")
  })
  default     = {}
  description = "Grafana Alloy scrape JMX kafka metrics"
}

variable "tolerations" {
  type = list(object({
    key               = string
    operator          = string
    value             = optional(string)
    effect            = string
    tolerationSeconds = optional(number)
  }))
  default     = []
  description = "Global tolerations for the Grafana Alloy"
}

variable "node_selector" {
  type        = map(string)
  default     = {}
  description = "Node selector for the Grafana Alloy"
}

variable "stability_level" {
  type        = string
  default     = "generally-available"
  description = "Stability level for grafana alloy. Needs to be 'experimental' for debug traces etc..."
}

variable "otel" {
  type = object({
    endpoint                  = optional(string, "http://tempo:9090")
    tenant_id                 = optional(string, null)
    service_graphs_dimensions = optional(list(string), [])
    span_metrics_dimensions   = optional(list(string), [])
    http_port                 = optional(number, 4318)
    grpc_port                 = optional(number, 4317)
    datadog_receiver_enabled  = optional(bool, false)
    datadog_port              = optional(number, 8126)
    bearer_token              = optional(string, null)
    logs_enabled              = optional(bool, false)
  })
  default     = {}
  description = "Grafana Alloy OTel settings. Set bearer_token to require Bearer Token authentication on the OTLP receiver. Set logs_enabled = true to also receive and forward OTLP logs to Loki."
}

variable "loki" {
  type = object({
    url            = optional(string, "http://loki:3100")
    tenant_id      = optional(string, "default")
    auth_enabled   = optional(bool, false)
    username       = optional(string, null)
    password       = optional(string, null)
    remote_timeout = optional(string, "30s")
  })
  default     = {}
  description = "Loki configuration for log forwarding. Required when otel.logs_enabled = true."
}

variable "kubernetes_kind" {
  type        = string
  default     = "deployment"
  description = "Grafana Alloy Kubernetes resource kind. Valid values are \"deployment\" or \"daemonset\"."

  validation {
    condition     = contains(["deployment", "daemonset"], var.kubernetes_kind)
    error_message = "Valid values for kubernetes_kind are \"deployment\" or \"daemonset\"."
  }
}

variable "clustering_enabled" {
  type        = bool
  default     = false
  description = "Enable Grafana Alloy clustering. NOTE: Only supported for deployment kind."
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Number of Grafana Alloy replicas."
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

variable "host_network" {
  type        = bool
  default     = null
  description = "Enable hostNetwork for the Grafana Alloy controller. When null, defaults to true for daemonset and false for deployment."
}

variable "ingress" {
  type = object({
    enabled            = optional(bool, false)
    ingress_class_name = optional(string, null)
    annotations        = optional(map(string), {})
    labels             = optional(map(string), {})
    path               = optional(string, "/")
    path_type          = optional(string, "Prefix")
    hosts              = optional(list(string), [])
    extra_paths        = optional(list(any), [])
    tls = optional(list(object({
      secret_name = optional(string)
      hosts       = optional(list(string), [])
    })), [])
    port = optional(number, 12345)
  })
  default     = {}
  description = "Ingress configuration for Grafana Alloy."

  validation {
    condition     = contains(["Prefix", "Exact", "ImplementationSpecific"], var.ingress.path_type)
    error_message = "Valid values for ingress.path_type are \"Prefix\", \"Exact\", or \"ImplementationSpecific\"."
  }

  validation {
    condition     = var.ingress.port > 0 && var.ingress.port < 65536
    error_message = "ingress.port must be a valid TCP port between 1 and 65535."
  }
}

variable "autoscaling" {
  type = object({
    min_replicas                      = optional(number, 2)
    max_replicas                      = optional(number, 5)
    target_cpu_utilization_percentage = optional(number, 80)
  })
  default     = {}
  description = "Autoscaling (HPA) configuration. Active when clustering_enabled = true."
}
