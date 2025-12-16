variable "namespace" {
  type        = string
  description = "Kubernetes namespace to deploy the Grafana Alloy into. NOTE: The namespace must exist and be available for deployment!"
}

variable "cluster_name" {
  type        = string
  description = "Kubernetes cluster name. NOTE: This gets injected into labels/attributes of all collected data."
}

variable "agent_name" {
  type        = string
  description = "Name of the Grafana Alloy."
}

variable "kubernetes_kind" {
  type        = string
  default     = "deployment"
  description = "Grafana Alloy Kubernetes resource kind. Valid values are \"deployment\" or \"daemonset\". If you want to use clustering, you should use \"deployment\" with multiple replicas."

  validation {
    condition     = contains(["deployment", "daemonset"], var.kubernetes_kind)
    error_message = "Valid values for kubernetes_kind are \"deployment\" or \"daemonset\"."
  }
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Number of Grafana Alloy replicas. NOTE: Only valid for `kubernetes_kind = \"deployment\"`."
}

variable "clustering_enabled" {
  type        = bool
  default     = false
  description = "Enable Grafana Alloy clustering. NOTE: This is only supported for certain kinds of resources - RTFM"
}

variable "default_config_enabled" {
  type        = bool
  default     = true
  description = "Enable default Grafana Alloy config templates. NOTE: Set this to `false` only if you want to use your own config without the enclosed templates."
}

variable "config" {
  type        = list(string)
  default     = []
  description = "Grafana Alloy River configuration. Some configuration should be provided. You're encouraged to use the provided templates. You can also provide your completely own config with `default_config_enabled = false`."
}

variable "agent_resources" {
  type = object({
    requests = optional(object({
      cpu    = optional(string, "100m")
      memory = optional(string, "256Mi")
    }), {})
    limits = optional(object({
      cpu    = optional(string, null)
      memory = optional(string, null)
    }), {})
  })
  default     = {}
  description = "Resources for the Grafana Alloy"
}

variable "kubernetes_security_context" {
  type = object({
    runAsUser  = optional(number)
    privileged = optional(bool)
  })
  default     = {}
  description = "Kubernetes security context configuration for the Grafana Alloy. This is needed with node_exporter to run privileged and as root (UID 0)."
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
  description = "Image registry for Grafana Alloy. This is meant to be used with custom pull-through proxies/registries."
}

variable "metrics" {
  type = object({
    endpoint     = optional(string, "http://mimir:9090")
    tenant       = optional(string, null)
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

variable "otel" {
  type = object({
    http_port                 = optional(number, 4318)
    grpc_port                 = optional(number, 4317)
    endpoint                  = optional(string, "http://tempo:4318")
    service_graphs_dimensions = optional(list(string), [])
  })
  default     = {}
  description = "Grafana Alloy OTel configuration. NOTE: There can be only one OTel receiver at the moment."
}

variable "host_volumes" {
  type = list(object({
    name       = string
    host_path  = string
    mount_path = string
  }))
  default     = []
  description = "Extra volumes to mount to the Grafana Alloy. This is needed for some integrations like node_exporter."
}

variable "envs" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = "Additional environment variables for the Grafana Alloy. You can use this attribute to provide additional secrets without exposing them in the config map output."
}

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "This role is for assuming by cloudwatch exporter"
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
  description = "Tolerations for the Grafana Alloy"
}

variable "node_selector" {
  type        = map(string)
  default     = {}
  description = "Node selector for the Grafana Alloy"
}

variable "k8s_pods" {
  type = object({
    scrape_pods_global     = optional(bool, false)
    scrape_pods_annotation = optional(string, "prometheus_io_scrape")
  })
  default     = {}
  description = "Grafana Alloy scrape settings for K8S pods"
}

variable "aws" {
  type = object({
    account = optional(string, "")
    region  = optional(string, "")
  })
  default     = {}
  description = "Grafana Alloy AWS configuration"
}

variable "loki" {
  type = object({
    url                    = optional(string, "http://loki:3100")
    tenant_id              = optional(string, "default")
    username               = optional(string, "admin")
    password               = optional(string, "admin")
    auth_enabled           = optional(bool, false)
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

variable "integrations" {
  type = object({
    otel_collector       = optional(bool, false)
    loki_logs            = optional(bool, false)
    k8s_cadvisor         = optional(bool, false)
    k8s_kubelet          = optional(bool, false)
    k8s_mimir_rules      = optional(bool, false)
    k8s_pods             = optional(bool, false)
    k8s_services         = optional(bool, false)
    node_exporter        = optional(bool, false)
    aws_alb              = optional(bool, false)
    aws_rds              = optional(bool, false)
    aws_sqs              = optional(bool, false)
    aws_mq               = optional(bool, false)
    aws_opensearch       = optional(bool, false)
    remote_write_metrics = optional(bool, true)
    kafka_jmx_metrics    = optional(bool, false)
  })
  default     = {}
  description = "Grafana Alloy integrations configuration"
}

variable "stability_level" {
  type    = string
  default = "generally-available"
}

variable "live_debug" {
  type        = bool
  default     = false
  description = "Enable live debug for the Grafana Alloy"
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
