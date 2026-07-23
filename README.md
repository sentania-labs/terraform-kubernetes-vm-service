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

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
