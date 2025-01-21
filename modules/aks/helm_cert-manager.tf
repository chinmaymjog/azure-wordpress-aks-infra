resource "null_resource" "crd" {
  depends_on = [
    azurerm_kubernetes_cluster.aks,
    local_file.azurek8s
  ]
  triggers = {
    version = var.cert_manager_version
  }

  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v${var.cert_manager_version}/cert-manager.crds.yaml"
    environment = {
      KUBECONFIG = "./azurek8s"
    }
  }
}

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

resource "null_resource" "cert_manager_clusterissuer_staging" {
  depends_on = [
    null_resource.crd,
    local_file.azurek8s
  ]
  count = var.env == "lab" || var.env == "dev" || var.env == "preprod" ? 1 : 0
  triggers = {
    version = var.cert_manager_version
  }

  provisioner "local-exec" {
    command = "kubectl apply -f - <<EOF\n${local.clusterissuer_staging}\nEOF"

    environment = {
      KUBECONFIG = "./azurek8s"
    }
  }
}

resource "null_resource" "cert_manager_clusterissuer_prod" {
  depends_on = [
    null_resource.crd,
    local_file.azurek8s
  ]
  count = var.env == "prod" ? 1 : 0
  triggers = {
    version = var.cert_manager_version
  }

  provisioner "local-exec" {
    command = "kubectl apply -f - <<EOF\n${local.clusterissuer_prod}\nEOF"

    environment = {
      KUBECONFIG = "./azurek8s"
    }
  }
}
