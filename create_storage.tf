resource "kubernetes_storage_class" "aws_ebs_sc" {
  metadata {
    name = "awsebs"
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Retain"
  parameters = {
    type = "io1"
  }
  volume_binding_mode = "WaitForFirstConsumer"
}

output namespace {
  value = kubernetes_namespace.devnamespace.metadata.0.name
}

output sc {
  value = kubernetes_storage_class.aws_ebs_sc.metadata.0.name
}

/*
resource "aws_ebs_volume" "wpebs" {
  availability_zone = "us-east-2a"
  size              = 5
  tags = {
    Name = "wpebs"
  }
}

resource "aws_ebs_volume" "mysqlebs" {
  availability_zone = "us-east-2a"
  size              = 20
  tags = {
    Name = "mysqlebs"
  }
}

resource "kubernetes_persistent_volume" "wp_pv" {
  metadata {
    name = "wp-pv"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      aws_elastic_block_store {
        volume_id = aws_ebs_volume.wpebs.id
        fs_type = "ext4"
      }
    }
    storage_class_name = kubernetes_storage_class.aws_ebs_sc.metadata.0.name
  }
}

resource "kubernetes_persistent_volume" "mysql_pv" {
  metadata {
    name = "mysql-pv"
  }
  spec {
    capacity = {
      storage = "20Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      aws_elastic_block_store {
        volume_id = aws_ebs_volume.mysqlebs.id
        fs_type = "xfs"
      }
    }
    storage_class_name = kubernetes_storage_class.aws_ebs_sc.metadata.0.name
  }
}
*/

resource "kubernetes_persistent_volume_claim" "wp_pvc" {
  metadata {
    name = "wppvc"
    namespace = kubernetes_namespace.devnamespace.metadata.0.name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    //volume_name = kubernetes_persistent_volume.wp_pv.metadata.0.name
    storage_class_name = kubernetes_storage_class.aws_ebs_sc.metadata.0.name
  }
  wait_until_bound = "false"
}

resource "kubernetes_persistent_volume_claim" "mysql_pvc" {
  metadata {
    name = "mysqlpvc"
    namespace = kubernetes_namespace.devnamespace.metadata.0.name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "20Gi"
      }
    }
    //volume_name = kubernetes_persistent_volume.mysql_pv.metadata.0.name
    storage_class_name = kubernetes_storage_class.aws_ebs_sc.metadata.0.name
  }
  wait_until_bound = "false"
}

output mysqlpvc{
 value = kubernetes_persistent_volume_claim.mysql_pvc
}