variable "namespace" {
  description = "value of the namespace to deploy the external-secrets"
  type        = string
  default     = "cluster-apps"
}

variable "cluster_name" {
  description = "name of the EKS cluster"
  type        = string
}

variable "project" {
  type = string
}

variable "loki" {
  description = "configuration for loki"
  type = object({
    url      = string
    username = optional(string, null)
    password = optional(string, null)
  })
}

variable "loki_scrape_global" {
  description = "loki scrape global"
  type        = bool
  default     = true
}

variable "loki_collect_self_logs_enabled" {
  description = "collect logs from alloy"
  type        = bool
  default     = false
}

variable "prometheus" {
  description = "configuration for prometheus"
  type = object({
    url      = string
    username = optional(string, null)
    password = optional(string, null)
  })
}

variable "node_template_file_path" {
  description = "path to node template file"
  type        = string
  default     = null
}

variable "cluster_template_file_path" {
  description = "path to cluster template file"
  type        = string
  default     = null
}

variable "tenant_id" {
  description = "tenant id"
  type        = string
  default     = "default"
}
