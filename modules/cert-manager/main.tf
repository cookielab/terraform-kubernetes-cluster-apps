locals {
  # cert-manager supports upgrading only one minor version at a time, always to
  # the latest patch release of that minor: https://cert-manager.io/docs/installation/upgrade/
  # Clusters lagging behind can step through the minors with `var.cert_manager_version`.
  cert_manager_default_version = "v1.21.3"
  cert_manager_version         = coalesce(var.cert_manager_version, local.cert_manager_default_version)
}

data "http" "cert_manager_crd" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/${local.cert_manager_version}/cert-manager.crds.yaml"
  request_headers = {
    Accept = "text/plain"
  }

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to download cert-manager CRDs from ${self.url}: HTTP ${self.status_code}."
    }
  }
}

locals {
  # Split on document separator lines only - CRD descriptions contain "---" too (since v1.16).
  # Decode every document without try - a parse error must fail the plan, not drop CRDs from it.
  cert_manager_crd_yamls = [for data in split("\n---\n", data.http.cert_manager_crd.response_body) : yamldecode(data)]

  # Keyed by CRD name - the order of the CRDs in the release manifest is not stable
  # (it changed in v1.19), and a replaced CRD takes every resource of its kind with it.
  cert_manager_crds = {
    for crd in local.cert_manager_crd_yamls : crd.metadata.name => crd
    if try(crd.kind, null) == "CustomResourceDefinition"
  }
}

resource "kubernetes_manifest" "cert_manager_crds" {
  for_each = local.cert_manager_crds
  manifest = each.value
}

resource "helm_release" "cert_manager" {
  name      = "cert-manager"
  namespace = var.namespace

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = local.cert_manager_version

  atomic = true
  wait   = true

  values = [yamlencode({
    nodeSelector = var.node_selector
    tolerations  = var.tolerations
    replicaCount = var.cert_manager_resources.replicas
    resources = {
      limits   = var.cert_manager_resources.limits
      requests = var.cert_manager_resources.requests
    }
    cainjector = {
      replicaCount = var.cainjector_resources.replicas
      resources = {
        limits   = var.cainjector_resources.limits
        requests = var.cainjector_resources.requests
      }
    }
    webhook = {
      replicaCount = var.webhook_resources.replicas
      resources = {
        limits   = var.webhook_resources.limits
        requests = var.webhook_resources.requests
      }
    }
  })]

  depends_on = [
    kubernetes_manifest.cert_manager_crds,
  ]
}
