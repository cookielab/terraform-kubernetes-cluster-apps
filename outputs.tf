output "namespace" {
  value = local.namespace
}

output "karpenter_role_name" {
  value = var.karpenter.enabled ? module.karpenter[0].karpenter_role_name : null
}
