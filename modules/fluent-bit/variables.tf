variable "namespace" {
  type        = string
  description = "The namespace to deploy the Fluent Bit service to"
  default     = "monitoring"
}

variable "logs_storage" {
  type        = string
  description = "The type of logs storage to use"
  default     = "loki"
}

variable "use_defaults" {
  type        = map(bool)
  description = "Whether to use the default outputs"
  default = {
    outputs = true
    filters = true
    inputs  = true
  }
}

variable "logs_endpoint_url" {
  type        = string
  description = "The URL of the logs endpoint"
}

variable "elasticsearch" {
  type = object({
    auth = optional(object({
      enabled  = optional(bool, false)
      username = optional(string)
      password = optional(string)
    }), {})
  })
  default = {}
}

variable "loki" {
  type = object({
    basic_auth = optional(object({
      enabled  = optional(bool, false)
      username = optional(string)
      password = optional(string)
    }), {})
    bearer_token = optional(object({
      enabled = optional(bool, false)
      token   = optional(string)
    }), {})
    tenant_id = optional(string, "default")
  })
  default = {}
}

variable "logs_labels" {
  type        = map(string)
  description = "The labels for the logs"
  default     = {}
}

variable "logs_custom" {
  type = object({
    outputs = optional(map(string), {})
    filters = optional(map(string), {})
    inputs  = optional(map(string), {})
  })
  description = "The custom configurations for logs, including outputs, filters, and inputs"
  default = {
    outputs = {}
    filters = {}
    inputs  = {}
  }
}




