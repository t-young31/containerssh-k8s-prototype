terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }

  required_version = ">=1.2.0"
}

provider "kubernetes" {
  config_path = "/etc/rancher/k3s/k3s.yaml"
}

resource "kubernetes_namespace" "containerssh" {
  metadata {
    name = "containerssh"
  }
}

resource "tls_private_key" "hostkey" {
  algorithm = "ED25519"
  rsa_bits  = 2048
}

resource "kubernetes_secret" "hostkey" {
  metadata {
    name      = "hostkey"
    namespace = kubernetes_namespace.containerssh.metadata[0].name
  }

  data = {
    # automagiclly gets base64 encoded
    "host.key" = tls_private_key.hostkey.private_key_pem
  }
}

resource "kubernetes_namespace" "containerssh_guests" {
  metadata {
    name = "containerssh-guests"
  }
}

resource "kubernetes_service_account" "containerssh" {
  metadata {
    name      = "containerssh"
    namespace = kubernetes_namespace.containerssh.metadata[0].name
  }
  automount_service_account_token = true
}

resource "kubernetes_role" "containerssh" {
  metadata {
    name      = "containerssh"
    namespace = kubernetes_namespace.containerssh_guests.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "pods/exec", "pods/logs"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "containerssh" {
  metadata {
    name      = "containerssh"
    namespace = kubernetes_namespace.containerssh_guests.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "containerssh"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "containerssh"
    namespace = kubernetes_namespace.containerssh.metadata[0].name
  }
}

resource "kubernetes_config_map" "containerssh" {
  metadata {
    name      = "containerssh-config"
    namespace = kubernetes_namespace.containerssh.metadata[0].name
  }

  data = {
    "config.yaml" = templatefile("${path.module}/config.template.yaml",
      {
        guest_namespace = kubernetes_namespace.containerssh_guests.metadata[0].name
    })
  }
}

resource "kubernetes_manifest" "deployment" {
  manifest = yamldecode(templatefile("${path.module}/deployment.template.yaml",
    {
      secret_name = kubernetes_secret.hostkey.metadata[0].name
    }
  ))
}

resource "kubernetes_service" "containerssh" {
  metadata {
    name      = "containerssh"
    namespace = kubernetes_namespace.containerssh.metadata[0].name
  }

  spec {
    selector = {
      app = "containerssh"
    }

    type = "LoadBalancer"

    port {
      protocol    = "TCP"
      port        = 2222
      target_port = 2222
    }
  }
}
