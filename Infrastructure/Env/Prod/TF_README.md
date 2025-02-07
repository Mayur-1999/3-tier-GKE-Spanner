<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_MySql"></a> [MySql](#module\_MySql) | ./modules/MySQL | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dbname"></a> [dbname](#input\_dbname) | The name for sample app database. | `string` | `"sample-app-db"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Region to deploy the resource. | `string` | `"us-east1"` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | Email ID of service account. | `string` | `""` | no |
| <a name="input_user"></a> [user](#input\_user) | sample app DB user username. | `string` | `"wpuser"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->