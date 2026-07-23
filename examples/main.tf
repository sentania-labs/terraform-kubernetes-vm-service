module "vm_service" {
  source = "../"

  name          = "web-01"
  namespace     = var.namespace
  image_name    = "ubuntu-22.04-x86_64"
  class_name    = "best-effort-small"
  storage_class = "wcp-vsan-default"

  ssh_authorized_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExampleExampleExampleExampleExample scott@corp.local",
  ]

  expose_ports = [
    { port = 22 },
    { port = 443, target_port = 8443 },
  ]
}
