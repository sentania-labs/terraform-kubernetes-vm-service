output "vm_name" {
  description = "Name of the created VirtualMachine."
  value       = kubernetes_manifest.this.manifest.metadata.name
}

output "service_name" {
  description = "Name of the created VirtualMachineService, or null if expose_ports is empty."
  value       = length(kubernetes_manifest.service) > 0 ? kubernetes_manifest.service[0].manifest.metadata.name : null
}

output "load_balancer_ip" {
  description = "Best-effort external IP of the VirtualMachineService's LoadBalancer. Often null on first apply — the vmoperator/cloud-provider only populates this status after a subsequent refresh/plan, not synchronously during apply."
  value       = length(kubernetes_manifest.service) > 0 ? try(kubernetes_manifest.service[0].object.status.loadBalancer.ingress[0].ip, null) : null
}
