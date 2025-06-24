variable "namespace" {
  type        = string
  description = "The namespace to install the VPA in"
  default     = "cluster-apps"
}

variable "helm_chart_version" {
  type        = string
  description = "The version of the VPA Helm chart to install"
  default     = "10.2.1"
}

variable "release_name" {
  type        = string
  description = "The name of the Helm release"
  default     = "vpa"
}

variable "crds" {
  type = object({
    enabled = optional(bool)
  })
  description = "The CRDs to install"
  default = {
    enabled = true
  }
}

variable "recommender" {
  type = object({
    enabled                 = optional(bool)
    replica_count           = optional(number)
    service_account_enabled = optional(bool)
    resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
  })
  description = "The VPA recommender configuration"
  default = {
    enabled                 = true
    replica_count           = 1
    service_account_enabled = true
    resources = {
      limits = {
        cpu    = "200m"
        memory = "200Mi"
      }
      requests = {
        cpu    = "50m"
        memory = "50Mi"
      }
    }
  }
}

variable "updater" {
  type = object({
    enabled                 = optional(bool)
    replica_count           = optional(number)
    service_account_enabled = optional(bool)
    resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
  })
  description = "The VPA updater configuration"
  default = {
    enabled                 = true
    replica_count           = 1
    service_account_enabled = true
    resources = {
      limits = {
        cpu    = "200m"
        memory = "200Mi"
      }
      requests = {
        cpu    = "50m"
        memory = "50Mi"
      }
    }
  }
}

variable "admissionController" {
  type = object({
    enabled                 = optional(bool)
    replica_count           = optional(number)
    service_account_enabled = optional(bool)
    resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
  })
  description = "The VPA admission controller configuration"
  default = {
    enabled                 = true
    replica_count           = 1
    service_account_enabled = true
    resources = {
      limits = {
        cpu    = "200m"
        memory = "200Mi"
      }
      requests = {
        cpu    = "50m"
        memory = "50Mi"
      }
    }
  }
}
