resource "kubernetes_namespace" "cert-manager" {
  depends_on = [
    azurerm_kubernetes_cluster.aks,
    local_file.azurek8s
  ]
  metadata {
    annotations = {
      name = "${var.project}-cert-manager"
    }

    labels = {
      mylabel = "${var.project}-cert-manager"
    }

    name = "${var.project}-cert-manager"
  }
  lifecycle {
    ignore_changes = [metadata.0.annotations]
  }
}

resource "helm_release" "cert-manager" {
  depends_on = [
    azurerm_kubernetes_cluster.aks,
    local_file.azurek8s
  ]
  name = "cert-manager"

  repository = var.cert_manager_repository
  chart      = "cert-manager"
  version    = var.cert_manager_version

  namespace = kubernetes_namespace.cert-manager.metadata.0.name

  set {
    name  = "installCRDs"
    value = "true"
  }
}

locals {
  clusterissuer_staging = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    email: ${var.support_email}
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
    - http01:
        ingress:
          class: nginx
EOF

  clusterissuer_prod = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: ${var.support_email}
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF
}

resource "kubernetes_manifest" "clusterissuer_staging" {
  depends_on = [
    helm_release.cert-manager
  ]
  count = var.env == "lab" || var.env == "dev" || var.env == "preprod" ? 1 : 0

  manifest = yamldecode(local.clusterissuer_staging)
}

resource "kubernetes_manifest" "clusterissuer_prod" {
  depends_on = [
    helm_release.cert-manager
  ]
  count = var.env == "prod" ? 1 : 0

  manifest = yamldecode(local.clusterissuer_prod)
}
