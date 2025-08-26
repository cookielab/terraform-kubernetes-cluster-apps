variable "namespace" {
  description = "value of the namespace to deploy the karpenter"
  type        = string
  default     = "cluster-apps"
}

variable "cluster_name" {
  description = "name of the EKS cluster"
  type        = string
}

variable "repository" {
  description = "repository of immage to deploy the karpenter"
  type        = string
  default     = "public.ecr.aws/karpenter/controller"
}

variable "node_selector" {
  description = "node selector to deploy the karpenter"
  type        = map(string)
  default = {
    "node.kubernetes.io/pool" = "critical"
  }
}

variable "tolerations" {
  description = "tolerations to deploy the karpenter"
  type = list(object({
    key      = string
    operator = string
    value    = optional(string, null)
    effect   = string
  }))
  default = [{
    key      = "CriticalAddonsOnly"
    operator = "Exists"
    effect   = "NoSchedule"
  }]
}

variable "replicas" {
  description = "number of replicas to deploy the karpenter"
  type        = number
  default     = 2
}

variable "tag_key" {
  description = "tag key to identify the EKS cluster"
  type        = string
  default     = "eks:eks-cluster-name"
}

variable "enable_disruption" {
  description = "enable disruption handler"
  type        = bool
  default     = true
}

variable "batch_max_duration" {
  description = "the maximum length of a batch window. the longer this is, the more pods we can consider for provisioning at one time which usually results in fewer but larger nodes."
  type        = string
  default     = "10s"
}

variable "batch_idle_duration" {
  description = "the maximum amount of time with no new ending pods that if exceeded ends the current batching window. If pods arrive faster than this time, the batching window will be extended up to the maxDuration. if they arrive slower, the pods will be batched separately."
  type        = string
  default     = "1s"
}

variable "spot_to_spot_consolidation" {
  description = "setting this to true will enable spot replacement consolidation for both single and multi-node consolidation."
  type        = bool
  default     = false
}

variable "pod_annotations" {
  description = "annotations to deploy the karpenter"
  type        = map(string)
  default     = {}
}

variable "node_role_arn" {
  description = "ARN of IAM role to assume by nodes spinned by karpenter"
  type        = string
  default     = null
}

variable "resources" {
  description = "container resources for Karpenter controller"
  type = object({
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }), {})
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }), {})
  })
  default = {
    requests = {
      cpu    = "100m"
      memory = "256Mi"
    }
    limits = {
      cpu    = "1"
      memory = "300Mi"
    }
  }
}
