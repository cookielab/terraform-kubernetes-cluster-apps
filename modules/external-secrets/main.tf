resource "helm_release" "external_secrets_operator" {
  name      = "external-secrets-operator"
  namespace = var.namespace

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.20.3"

  values = [yamlencode({
    replicaCount = var.resources.replicas
    image = {
      repository = var.repository
    }
    global = {
      nodeSelector = var.node_selector
      tolerations  = var.tolerations
    }
    resources = var.resources
    webhook = {
      replicaCount = var.webhook_resources.replicas
      resources    = var.webhook_resources
    }
    certController = {
      replicaCount = var.cert_controller_resources.replicas
      resources    = var.cert_controller_resources
    }
  })]
}
