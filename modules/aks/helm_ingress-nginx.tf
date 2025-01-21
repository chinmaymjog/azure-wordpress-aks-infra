resource "kubernetes_namespace" "ingress-nginx" {
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
  metadata {
    annotations = {
      name = "${var.project}-ingress-nginx"
    }

    labels = {
      mylabel = "${var.project}-ingress-nginx"
    }

    name = "${var.project}-ingress-nginx"
  }
  lifecycle {
    ignore_changes = [metadata.0.annotations]
  }
}

resource "helm_release" "ingress-nginx" {
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
  name = "ingress-nginx"

  repository = var.ingress_nginx_repository
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_version

  namespace = kubernetes_namespace.ingress-nginx.metadata.0.name
  values = [
    <<EOF
controller:
  kind: DaemonSet
  service:
    type: LoadBalancer
    loadBalancerIP: ${azurerm_public_ip.inbound-ip.ip_address}
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-resource-group: ${azurerm_resource_group.rg_aks.name}
    externalTrafficPolicy: Local
  config:
    use-forwarded-headers:  "true"
    log-format-escape-json: "true"
    ssl-redirect-code: "308"
    hsts: "true"
    hsts-include-subdomains: "true"
    hsts-max-age: "31536000"
    config-global: |
    config-frontend: |
      capture request header Host len 150
      capture request header Referer len 250
      capture request header X-Forwarded-For len 150
      capture request header User-Agent len 350
      capture request header Cookie len 350
      capture response header Location len 150
      capture response header Server len 150
      capture cookie *.sid len 150
      unique-id-format %%{+X}o\ %ci%cp_%fi%fp_%Ts_%rt%pid
      unique-id-header X-Request-ID
EOF
  ]
}
