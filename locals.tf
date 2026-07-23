locals {
  cloud_init_secret_name = "${var.name}-cloud-init"
  service_name           = "${var.name}-svc"

  cloud_init_user_data = format(
    "#cloud-config\n%s%s",
    yamlencode({ ssh_authorized_keys = var.ssh_authorized_keys }),
    var.cloud_init_extra != null && var.cloud_init_extra != "" ? "\n${var.cloud_init_extra}" : ""
  )
}
