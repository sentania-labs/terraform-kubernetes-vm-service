variable "name" {
  type        = string
  description = "Name of the VirtualMachine (and prefix for its associated Secret/Service objects)."
}

variable "namespace" {
  type        = string
  description = "Supervisor namespace to create the VM Service objects in."
}

variable "image_name" {
  type        = string
  description = "Name of the content-library VM image to use (VirtualMachine spec.imageName)."
}

variable "class_name" {
  type        = string
  description = "Name of the VM Service VirtualMachineClass to use (VirtualMachine spec.className)."
}

variable "storage_class" {
  type        = string
  description = "Name of the StorageClass to use (VirtualMachine spec.storageClass)."
}

variable "ssh_authorized_keys" {
  type        = list(string)
  description = "Public keys to authorize for the guest's default user via cloud-init."

  validation {
    condition     = length(var.ssh_authorized_keys) > 0
    error_message = "ssh_authorized_keys must contain at least one key."
  }
}

variable "cloud_init_extra" {
  type        = string
  default     = ""
  description = "Raw cloud-config YAML (top-level keys only, no '#cloud-config' header) appended to the generated user-data. Nothing sensitive is baked in by this module; whatever is passed here or in ssh_authorized_keys is the caller's responsibility."
}

variable "expose_ports" {
  type = list(object({
    port        = number
    target_port = optional(number)
    protocol    = optional(string, "TCP")
  }))
  default     = [{ port = 22 }]
  description = "Ports to expose via a LoadBalancer VirtualMachineService. Pass an empty list to skip creating the VirtualMachineService entirely."
}

variable "vmoperator_api_version" {
  type        = string
  description = "apiVersion for vmoperator.vmware.com VirtualMachine/VirtualMachineService objects. v1alpha5 is preferred and is the default; older supervisors that don't yet serve v1alpha5 can override this variable with v1alpha1 through v1alpha4, which are also still served."
  default     = "vmoperator.vmware.com/v1alpha5"
}
