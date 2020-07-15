resource "kubernetes_pod" "wordpress" {
  metadata {
    name = "wordpress"
    namespace = kubernetes_namespace.devnamespace.metadata.0.name
    labels = {
      App = "wordpress"
    }
  }

  spec {
    container {
      image = "wordpress:4.8-apache"
      name  = "wordpress"
      
      env{
          name = "WORDPRESS_DB_HOST"
          value = kubernetes_service.mysql.metadata.0.name
       }
       env{
           name = "MYSQL_ROOT_PASSWORD"
           value = kubernetes_secret.mysql-pass.data.password
       }
      port {
        container_port = 80
      }
      volume_mount {
          mount_path = "/var/www/html"
          name = "pvc-for-cont"
      }
    }
   volume {
    name = "pvc-for-cont"
    persistent_volume_claim {
       claim_name = kubernetes_persistent_volume_claim.wp_pvc.metadata.0.name
    }   
   }
  }
}

resource "kubernetes_service" "wplb" {
  metadata {
    name = "wp-lb"
    namespace = kubernetes_namespace.devnamespace.metadata.0.name
  }
  spec {
    selector = {
      App = kubernetes_pod.wordpress.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

output loadBalancer {
  value = kubernetes_service.wplb
}