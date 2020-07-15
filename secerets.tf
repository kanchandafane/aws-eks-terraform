resource "kubernetes_secret" "mysql-pass" {
  metadata {
    name = "mysql-pass"
    namespace = kubernetes_namespace.devnamespace.metadata.0.name
  }

  data = {
    user = "admin"
    password = "P4ssw0rd"
  }
  type = "kubernetes.io/basic-auth"
}