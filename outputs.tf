output "namespace" {
  value = local.namespace
}

output "karpenter_node_role_name" {
  value = module.karpenter[0].node_role_name
}
