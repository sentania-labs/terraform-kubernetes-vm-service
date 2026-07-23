# terraform-kubernetes-vm-service

Creates one VM Service VM in a VCF Automation All Apps supervisor namespace:
a `VirtualMachine`, its cloud-init bootstrap `Secret`, and an optional
LoadBalancer `VirtualMachineService` (default port 22). Nothing else.

Registry address: `sentania-labs/vm-service/kubernetes`.

## Open item: vmoperator apiVersion

The `vmoperator.vmware.com` apiVersion used by `VirtualMachine` and
`VirtualMachineService` is unresolved between `v1alpha2` and `v1alpha3` as of
authoring. It is exposed as the `vmoperator_api_version` variable with a sane
default rather than hard-coded; live verification against the target cluster
(`kubectl api-resources`) happens at Track B checkpoint #1 of the all-apps
private cloud port. Update the default once confirmed.

## Cloud-init bootstrap Secret

The module builds a minimal `#cloud-config` document (`ssh_authorized_keys`
plus any `cloud_init_extra` appended verbatim as additional top-level YAML)
and stores it in a `stringData.user-data` key of a `Secret`. The
`VirtualMachine` references it via
`spec.bootstrap.cloudInit.rawCloudConfig.{name,key}`, matching the
`SecretKeySelector` shape (`name`/`key`) used by both `v1alpha2` and
`v1alpha3` of the vmoperator API — confirmed against the upstream
[vm-operator](https://github.com/vmware-tanzu/vm-operator) API types at
authoring time.

## `load_balancer_ip` output

`kubernetes_manifest` only surfaces the live object's status
(`object.status...`) after the provider has re-read it, which typically
means it stays `null` on the same `apply` that creates the
`VirtualMachineService` and only populates on a subsequent `plan`/`apply`
once the cloud provider has assigned an address. This is an accepted
limitation of the architecture, not a bug to work around in this module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.cloud_init](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_class_name"></a> [class\_name](#input\_class\_name) | Name of the VM Service VirtualMachineClass to use (VirtualMachine spec.className). | `string` | n/a | yes |
| <a name="input_cloud_init_extra"></a> [cloud\_init\_extra](#input\_cloud\_init\_extra) | Raw cloud-config YAML (top-level keys only, no '#cloud-config' header) appended to the generated user-data. Nothing sensitive is baked in by this module; whatever is passed here or in ssh\_authorized\_keys is the caller's responsibility. | `string` | `""` | no |
| <a name="input_expose_ports"></a> [expose\_ports](#input\_expose\_ports) | Ports to expose via a LoadBalancer VirtualMachineService. Pass an empty list to skip creating the VirtualMachineService entirely. | <pre>list(object({<br/>    port        = number<br/>    target_port = optional(number)<br/>    protocol    = optional(string, "TCP")<br/>  }))</pre> | <pre>[<br/>  {<br/>    "port": 22<br/>  }<br/>]</pre> | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Name of the content-library VM image to use (VirtualMachine spec.imageName). | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the VirtualMachine (and prefix for its associated Secret/Service objects). | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Supervisor namespace to create the VM Service objects in. | `string` | n/a | yes |
| <a name="input_ssh_authorized_keys"></a> [ssh\_authorized\_keys](#input\_ssh\_authorized\_keys) | Public keys to authorize for the guest's default user via cloud-init. | `list(string)` | n/a | yes |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Name of the StorageClass to use (VirtualMachine spec.storageClass). | `string` | n/a | yes |
| <a name="input_vmoperator_api_version"></a> [vmoperator\_api\_version](#input\_vmoperator\_api\_version) | apiVersion for vmoperator.vmware.com VirtualMachine/VirtualMachineService objects (unresolved: v1alpha2 vs v1alpha3 as of authoring; verify against the target cluster with `kubectl api-resources` before relying on the default). | `string` | `"vmoperator.vmware.com/v1alpha2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_load_balancer_ip"></a> [load\_balancer\_ip](#output\_load\_balancer\_ip) | Best-effort external IP of the VirtualMachineService's LoadBalancer. Often null on first apply — the vmoperator/cloud-provider only populates this status after a subsequent refresh/plan, not synchronously during apply. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Name of the created VirtualMachineService, or null if expose\_ports is empty. |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | Name of the created VirtualMachine. |
<!-- END_TF_DOCS -->
