locals {
  cert_manager_version = "v1.14.2"
}

data "http" "cert_manager_crd" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/${local.cert_manager_version}/cert-manager.crds.yaml"
  request_headers = {
    Accept = "text/plain"
  }
}

locals {
  cert_manager_crd_yamls = [for data in split("---", data.http.cert_manager_crd.response_body) : yamldecode(data)]
}

resource "kubernetes_manifest" "cert_manager_crds" {
  count    = length(local.cert_manager_crd_yamls)
  manifest = local.cert_manager_crd_yamls[count.index]
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
    resources    = var.cert_manager_resources
    cainjector = {
      replicaCount = var.cainjector_resources.replicas
      resources    = var.cainjector_resources
    }
    webhook = {
      replicaCount = var.webhook_resources.replicas
      resources    = var.webhook_resources
    }
  })]
}
