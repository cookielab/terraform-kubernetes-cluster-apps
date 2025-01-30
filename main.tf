resource "kubernetes_namespace_v1" "this" {
  count = var.namespace.create ? 1 : 0

  metadata {
    name = var.namespace.name
  }

  lifecycle {
    ignore_changes = [ # rancher annotations
      metadata[0].annotations["cattle.io/status"],
      metadata[0].annotations["lifecycle.cattle.io/create.namespace-auth"],
      metadata[0].annotations["field.cattle.io/projectId"],
      metadata[0].annotations["management.cattle.io/no-default-sa-token"]
    ]
  }
}

locals {
  namespace = var.namespace.create ? kubernetes_namespace_v1.this[0].metadata[0].name : var.namespace.name
}

module "metrics_server" {
  count = var.metrics_server.enabled ? 1 : 0

  source = "./modules/metrics-server"

  namespace     = local.namespace
  repository    = var.metrics_server.repository
  node_selector = var.metrics_server.node_selector != null ? var.metrics_server.node_selector : var.node_selector
  tolerations   = var.metrics_server.tolerations != null ? var.metrics_server.tolerations : var.tolerations
}

module "karpenter" {
  count = var.karpenter.enabled ? 1 : 0

  source = "./modules/karpenter"

  namespace                  = local.namespace
  cluster_name               = var.cluster_name
  repository                 = var.karpenter.repository
  node_selector              = var.karpenter.node_selector != null ? var.karpenter.node_selector : var.node_selector
  tolerations                = var.karpenter.tolerations != null ? var.karpenter.tolerations : var.tolerations
  replicas                   = var.karpenter.replicas
  tag_key                    = var.karpenter.tag_key
  enable_disruption          = var.karpenter.enable_disruption
  batch_max_duration         = var.karpenter.batch_max_duration
  batch_idle_duration        = var.karpenter.batch_idle_duration
  spot_to_spot_consolidation = var.karpenter.spot_to_spot_consolidation
  pod_annotations            = var.karpenter.pod_annotations
  node_role_arn              = var.karpenter.node_role_arn
}

module "external_secrets" {
  count = var.external_secrets.enabled ? 1 : 0

  source = "./modules/external-secrets"

  namespace     = local.namespace
  repository    = var.external_secrets.repository
  node_selector = var.external_secrets.node_selector != null ? var.external_secrets.node_selector : var.node_selector
  tolerations   = var.external_secrets.tolerations != null ? var.external_secrets.tolerations : var.tolerations
}

module "kyverno" {
  count = var.kyverno.enabled ? 1 : 0

  source = "./modules/kyverno"

  namespace            = local.namespace
  registry             = var.kyverno.registry
  docker_hub_registry  = var.kyverno.docker_hub_registry
  node_selector        = var.kyverno.node_selector != null ? var.kyverno.node_selector : var.node_selector
  tolerations          = var.kyverno.tolerations != null ? var.kyverno.tolerations : var.tolerations
  admission_controller = var.kyverno.admission_controller
}

module "alloy" {
  count = var.alloy.enabled ? 1 : 0

  source = "./modules/alloy"

  namespace                      = local.namespace
  loki                           = var.alloy.loki
  loki_scrape_global             = var.alloy.loki_scrape_global
  loki_collect_self_logs_enabled = var.alloy.loki_collect_self_logs_enabled
  prometheus                     = var.alloy.prometheus
  tenant_id                      = var.alloy.tenant_id
  node_template_file_path        = var.alloy.node_template_file_path
  cluster_template_file_path     = var.alloy.cluster_template_file_path

  cluster_name = var.cluster_name
  project      = var.project
}

module "cert_manager" {
  count = var.cert_manager.enabled ? 1 : 0

  source = "./modules/cert-manager"

  namespace     = local.namespace
  node_selector = var.cert_manager.node_selector != null ? var.cert_manager.node_selector : var.node_selector
  tolerations   = var.cert_manager.tolerations != null ? var.cert_manager.tolerations : var.tolerations
}
