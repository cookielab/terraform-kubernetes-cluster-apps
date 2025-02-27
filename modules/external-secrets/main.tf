resource "helm_release" "external_secrets_operator" {
  name      = "external-secrets-operator"
  namespace = var.namespace

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.14.3"

  values = [yamlencode({
    image = {
      repository = var.repository
    }
    global = {
      nodeSelector = var.node_selector
      tolerations  = var.tolerations
    }
  })]
}
