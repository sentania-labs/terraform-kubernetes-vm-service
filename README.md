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
<!-- END_TF_DOCS -->
