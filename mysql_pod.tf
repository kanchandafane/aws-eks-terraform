resource "kubernetes_pod" "mysql" {
  metadata {
    name = "mysql"
    namespace = kubernetes_namespace.devnamespace.metadata.0.name
    labels = {
      App = "mysql"
    }
  }

  spec {
    container {
      image = "mysql:5.6"
      name  = "mysql"
      
      env {
             name = "MYSQL_ROOT_PASSWORD"
             value = kubernetes_secret.mysql-pass.data.password
      }
      port {
        container_port = 3306
      }
      volume_mount {
          mount_path = "/var/lib/mysql"
          name = "mysqlstorage"
      }
    }
   volume {
    name = "mysqlstorage"
    persistent_volume_claim {
       claim_name = kubernetes_persistent_volume_claim.mysql_pvc.metadata.0.name
    }  
   }
  }
}

resource "kubernetes_service" "mysql" {
  metadata {
    name = "mysql-service"
    namespace = kubernetes_namespace.devnamespace.metadata.0.name
  }
  spec {
    selector = {
      App = kubernetes_pod.mysql.metadata[0].labels.App
    }
    port {
      port        = 3306
      target_port = 3306
    }
    type = "ClusterIP"
  }
}

output clusterip {
  value = kubernetes_service.mysql
}