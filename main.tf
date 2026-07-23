resource "kubernetes_manifest" "cloud_init" {
  manifest = {
    apiVersion = "v1"
    kind       = "Secret"

    metadata = {
      name      = local.cloud_init_secret_name
      namespace = var.namespace
    }

    type = "Opaque"

    stringData = {
      user-data = local.cloud_init_user_data
    }
  }
}

resource "kubernetes_manifest" "this" {
  manifest = {
    apiVersion = var.vmoperator_api_version
    kind       = "VirtualMachine"

    metadata = {
      name      = var.name
      namespace = var.namespace
      labels = {
        app = var.name
      }
    }

    spec = {
      imageName    = var.image_name
      className    = var.class_name
      storageClass = var.storage_class

      bootstrap = {
        cloudInit = {
          rawCloudConfig = {
            name = local.cloud_init_secret_name
            key  = "user-data"
          }
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service" {
  count = length(var.expose_ports) > 0 ? 1 : 0

  manifest = {
    apiVersion = var.vmoperator_api_version
    kind       = "VirtualMachineService"

    metadata = {
      name      = local.service_name
      namespace = var.namespace
    }

    spec = {
      type = "LoadBalancer"

      selector = {
        app = var.name
      }

      ports = [
        for p in var.expose_ports : {
          name       = "port-${p.port}"
          protocol   = coalesce(p.protocol, "TCP")
          port       = p.port
          targetPort = coalesce(p.target_port, p.port)
        }
      ]
    }
  }
}
