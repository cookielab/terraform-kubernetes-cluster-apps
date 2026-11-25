# The CRDs used to be created with count, in the order of the v1.14 - v1.18 release manifests.
moved {
  from = kubernetes_manifest.cert_manager_crds[0]
  to   = kubernetes_manifest.cert_manager_crds["certificaterequests.cert-manager.io"]
}

moved {
  from = kubernetes_manifest.cert_manager_crds[1]
  to   = kubernetes_manifest.cert_manager_crds["certificates.cert-manager.io"]
}

moved {
  from = kubernetes_manifest.cert_manager_crds[2]
  to   = kubernetes_manifest.cert_manager_crds["challenges.acme.cert-manager.io"]
}

moved {
  from = kubernetes_manifest.cert_manager_crds[3]
  to   = kubernetes_manifest.cert_manager_crds["clusterissuers.cert-manager.io"]
}

moved {
  from = kubernetes_manifest.cert_manager_crds[4]
  to   = kubernetes_manifest.cert_manager_crds["issuers.cert-manager.io"]
}

moved {
  from = kubernetes_manifest.cert_manager_crds[5]
  to   = kubernetes_manifest.cert_manager_crds["orders.acme.cert-manager.io"]
}
