<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_allow-ssh-fw-001"></a> [allow-ssh-fw-001](#module\_allow-ssh-fw-001) | ./modules/firewall | n/a |
| <a name="module_gbg-app-fw-001"></a> [gbg-app-fw-001](#module\_gbg-app-fw-001) | ./modules/firewall | n/a |
| <a name="module_spanner"></a> [spanner](#module\_spanner) | ./modules/spanner | n/a |
| <a name="module_sre-cluster"></a> [sre-cluster](#module\_sre-cluster) | ./modules/gke | n/a |
| <a name="module_usc1-trust-vpc-001"></a> [usc1-trust-vpc-001](#module\_usc1-trust-vpc-001) | ./modules/vpc | n/a |
| <a name="module_usc1-trustsubnet-001"></a> [usc1-trustsubnet-001](#module\_usc1-trustsubnet-001) | ./modules/subnet | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | n/a | yes |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | n/a | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->