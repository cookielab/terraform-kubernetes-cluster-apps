resource "helm_release" "external_secrets_operator" {
  name      = "external-secrets-operator"
  namespace = var.namespace

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.18.2"

  values = [yamlencode({
    image = {
      repository = var.repository
    }
    global = {
      nodeSelector = var.node_selector
      tolerations  = var.tolerations
    }
    resources = var.resources
    webhook = {
      resources = var.webhook_resources
    }
    certController = {
      resources = var.cert_controller_resources
    }
  })]
}
