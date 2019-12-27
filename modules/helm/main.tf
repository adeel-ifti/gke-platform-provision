
provider "helm" {
  tiller_image = "gcr.io/kubernetes-helm/tiller:${var.helm_version}"
  service_account = kubernetes_service_account.tiller.metadata[0].name
  kubernetes {
    host                   = var.endpoint
    token                  = "${data.google_client_config.current.access_token}"
    client_certificate     = var.client_certificate
    client_key             = var.client_key
    cluster_ca_certificate = var.client_ca_certificate
  }
}
provider "kubernetes"{
    host                   = var.endpoint
    token                  = "${data.google_client_config.current.access_token}"
    client_certificate     = var.client_certificate
    client_key             = var.client_key
    cluster_ca_certificate = var.client_ca_certificate

}
resource "null_resource" "delay" {
    provisioner "local-exec" {
        command = "sleep 60"
    }
    depends_on = ["helm_release.istio-init"]
}

data "google_client_config" "current" {}

resource "helm_release" "nginx-ingress" {
  name  = "nginx-ingress"
  chart = "stable/nginx-ingress"
  namespace = "nginx-ingress"
  # depends_on = ["null_resource.delay"]

}
resource "helm_release" "istio-init" {
  name  = "istio-init"
  chart = "../modules/helm/istio/istio-init"
  namespace = "istio-system"
  

}
resource "helm_release" "istio" {
  name  = "istio"
  chart = "../modules/helm/istio/istio"
  namespace = "istio-system"
  depends_on = ["null_resource.delay"]
   set {
    name  = "gateways.istio-ingressgateway.enabled"
    value = "false"
  }
  set {
    name  = "gateways.istio-ilbgateway.enabled"
    value = "true"
  }
  set {
    name  = "global.configValidation"
    value = "false"
  }
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
  automount_service_account_token = true
  
}

resource "kubernetes_cluster_role_binding" "user" {
  metadata {
    name = "admin-user"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  

  # We give the Tiller ServiceAccount cluster admin status so that we can deploy anything in any namespace using this
  # Tiller instance for testing purposes. In production, you might want to use a more restricted role.
  subject {
    # this is a workaround for https://github.com/terraform-providers/terraform-provider-kubernetes/issues/204.
    # we have to set an empty api_group or the k8s call will fail. It will be fixed in v1.5.2 of the k8s provider.
    api_group = ""

    kind      = "ServiceAccount"
    name      = var.service_account_name
    namespace = "kube-system"
  }

  
}