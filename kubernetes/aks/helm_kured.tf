resource "kubernetes_namespace" "kured" {
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
  metadata {
    annotations = {
      name = "${var.project}-kured"
    }

    labels = {
      mylabel = "${var.project}-kured"
    }

    name = "${var.project}-kured"
  }
  lifecycle {
    ignore_changes = [metadata.0.annotations]
  }
}

resource "helm_release" "kured" {
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
  name = "kured"

  repository = var.kured_repository
  chart      = "kured"
  version    = var.kured_version

  namespace = kubernetes_namespace.kured.metadata.0.name
}