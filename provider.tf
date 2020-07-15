provider "kubernetes" {
  config_context_auth_info = "labuser@cluster-eks.us-east-2.eksctl.io"
  config_context_cluster   = "cluster-eks.us-east-2.eksctl.io"
}

provider "aws" {
  region  = "us-east-2"
}

resource "kubernetes_namespace" "devnamespace" {
  metadata {
    name = "dev"
  }
  
}

resource "kubernetes_cluster_role_binding" "terraformadmin" {
  metadata {
    name = "terraformadmin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
    subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = kubernetes_namespace.devnamespace.metadata.0.name
  }
    subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "kube_system"
  } 
}