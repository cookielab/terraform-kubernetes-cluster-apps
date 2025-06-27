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

module "keda" {
  count  = var.keda.enabled ? 1 : 0
  source = "./modules/keda"

  namespace       = var.keda.namespace
  repository      = var.keda.repository
  replicas        = var.keda.replicas
  log_level       = var.keda.log_level
  metrics_server  = var.keda.metrics_server
  node_selector   = var.keda.node_selector
  tolerations     = var.keda.tolerations
  pod_annotations = var.keda.pod_annotations
  role_arn        = var.keda.role_arn
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

module "fluent-bit" {
  count = var.fluent_bit.enabled ? 1 : 0

  source = "./modules/fluent-bit"

  namespace       = local.namespace
  logs_storage    = var.fluent_bit.logs_storage
  tolerations     = var.fluent_bit.tolerations
  node_selector   = var.fluent_bit.node_selector
  labels          = var.fluent_bit.labels
  pod_annotations = var.fluent_bit.pod_annotations
  loki = {
    tenant_id = var.fluent_bit.loki.tenant_id
    basic_auth = {
      enabled  = var.fluent_bit.loki.basic_auth.enabled
      username = var.fluent_bit.loki.basic_auth.username
      password = var.fluent_bit.loki.basic_auth.password
    }
    bearer_token = {
      enabled = var.fluent_bit.loki.bearer_token.enabled
      token   = var.fluent_bit.loki.bearer_token.token
    }
  }
  elasticsearch = {
    auth = {
      enabled  = var.fluent_bit.elasticsearch.auth.enabled
      username = var.fluent_bit.elasticsearch.auth.username
      password = var.fluent_bit.elasticsearch.auth.password
    }
  }
  use_defaults = {
    outputs = var.fluent_bit.use_defaults.outputs
    filters = var.fluent_bit.use_defaults.filters
    inputs  = var.fluent_bit.use_defaults.inputs
  }
  logs_custom = {
    outputs = var.fluent_bit.logs_custom.outputs
    filters = var.fluent_bit.logs_custom.filters
    inputs  = var.fluent_bit.logs_custom.inputs
  }
  logs_endpoint_url = var.fluent_bit.logs_endpoint_url


}

module "grafana_alloy_cluster" {
  count = var.grafana_alloy.cluster.enabled ? 1 : 0

  source                  = "cookielab/grafana-alloy/kubernetes//modules/cluster"
  version                 = "v0.0.6"
  kubernetes_cluster_name = var.cluster_name
  chart_version           = "0.12.5"
  kubernetes_namespace    = local.namespace

  replicas = var.grafana_alloy.cluster.replicas
  metrics = {
    endpoint    = var.grafana_alloy.metrics.endpoint
    tenant      = var.grafana_alloy.metrics.tenant
    ssl_enabled = var.grafana_alloy.metrics.ssl_enabled
  }
  image = {
    repository = var.grafana_alloy.image.repository
  }


  agent_resources = {
    requests = {
      cpu    = var.grafana_alloy.cluster.requests.cpu
      memory = var.grafana_alloy.cluster.requests.memory
    }
    limits = {
      cpu    = var.grafana_alloy.cluster.limits.cpu
      memory = var.grafana_alloy.cluster.limits.memory
    }

  }
}

module "grafana_alloy_loki" {
  count = var.grafana_alloy.loki.enabled ? 1 : 0

  source                  = "cookielab/grafana-alloy/kubernetes//modules/loki-logs"
  version                 = "v0.0.6"
  kubernetes_cluster_name = var.cluster_name
  chart_version           = "0.12.5"
  kubernetes_namespace    = local.namespace

  replicas = var.grafana_alloy.loki.replicas
  metrics = {
    endpoint    = var.grafana_alloy.metrics.endpoint
    tenant      = var.grafana_alloy.metrics.tenant
    ssl_enabled = var.grafana_alloy.metrics.ssl_enabled
  }

  loki = {
    tenant_id              = var.grafana_alloy.loki.tenant_id
    url                    = var.grafana_alloy.loki.url
    username               = var.grafana_alloy.loki.username
    password               = var.grafana_alloy.loki.password
    scrape_pods_global     = var.grafana_alloy.loki.scrape_pods_global
    scrape_pods_annotation = var.grafana_alloy.loki.scrape_pods_annotation
    scrape_logs_method     = var.grafana_alloy.loki.scrape_logs_method
  }
  clustering_enabled = var.grafana_alloy.loki.clustering_enabled
  image = {
    repository = var.grafana_alloy.image.repository
  }

  aws = var.grafana_alloy.aws

  agent_resources = {
    requests = {
      cpu    = var.grafana_alloy.cluster.requests.cpu
      memory = var.grafana_alloy.cluster.requests.memory
    }
    limits = {
      cpu    = var.grafana_alloy.cluster.limits.cpu
      memory = var.grafana_alloy.cluster.limits.memory
    }

  }
}

module "grafana_alloy_node" {
  count = var.grafana_alloy.node.enabled ? 1 : 0

  source                  = "cookielab/grafana-alloy/kubernetes//modules/node"
  version                 = "v0.0.6"
  kubernetes_cluster_name = var.cluster_name
  chart_version           = "0.12.5"
  kubernetes_namespace    = local.namespace

  metrics = {
    endpoint    = var.grafana_alloy.metrics.endpoint
    tenant      = var.grafana_alloy.metrics.tenant
    ssl_enabled = var.grafana_alloy.metrics.ssl_enabled
  }
  image = {
    repository = var.grafana_alloy.image.repository
  }
  agent_resources = {
    requests = {
      cpu    = var.grafana_alloy.node.requests.cpu
      memory = var.grafana_alloy.node.requests.memory
    }
    limits = {
      cpu    = var.grafana_alloy.node.limits.cpu
      memory = var.grafana_alloy.node.limits.memory
    }
  }

}

module "cert_manager" {
  count = var.cert_manager.enabled ? 1 : 0

  source = "./modules/cert-manager"

  namespace     = local.namespace
  node_selector = var.cert_manager.node_selector != null ? var.cert_manager.node_selector : var.node_selector
  tolerations   = var.cert_manager.tolerations != null ? var.cert_manager.tolerations : var.tolerations
}

module "vpa" {
  count = var.vpa.enabled ? 1 : 0

  source = "./modules/vpa"

  namespace    = local.namespace
  release_name = var.vpa.release_name
  crds = {
    enabled = var.vpa.crds.enabled
  }
  recommender = {
    enabled                 = var.vpa.recommender.enabled
    replica_count           = var.vpa.recommender.replica_count
    service_account_enabled = var.vpa.recommender.service_account_enabled
    resources = {
      limits = {
        cpu    = var.vpa.recommender.resources.limits.cpu
        memory = var.vpa.recommender.resources.limits.memory
      }
      requests = {
        cpu    = var.vpa.recommender.resources.requests.cpu
        memory = var.vpa.recommender.resources.requests.memory
      }
    }
  }
  updater = {
    enabled                 = var.vpa.updater.enabled
    replica_count           = var.vpa.updater.replica_count
    service_account_enabled = var.vpa.updater.service_account_enabled
    resources = {
      limits = {
        cpu    = var.vpa.updater.resources.limits.cpu
        memory = var.vpa.updater.resources.limits.memory
      }
      requests = {
        cpu    = var.vpa.updater.resources.requests.cpu
        memory = var.vpa.updater.resources.requests.memory
      }
    }
  }
  admissionController = {
    enabled                 = var.vpa.admissionController.enabled
    replica_count           = var.vpa.admissionController.replica_count
    service_account_enabled = var.vpa.admissionController.service_account_enabled
    resources = {
      limits = {
        cpu    = var.vpa.admissionController.resources.limits.cpu
        memory = var.vpa.admissionController.resources.limits.memory
      }
      requests = {
        cpu    = var.vpa.admissionController.resources.requests.cpu
        memory = var.vpa.admissionController.resources.requests.memory
      }
    }
  }
}
