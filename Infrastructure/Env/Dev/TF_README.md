<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_MySql"></a> [MySql](#module\_MySql) | ./modules/MySQL | n/a |
| <a name="module_app-fw"></a> [app-fw](#module\_app-fw) | ./modules/firewall | n/a |
| <a name="module_proxy-subnet"></a> [proxy-subnet](#module\_proxy-subnet) | ./modules/subnet | n/a |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | ./modules/subnet | n/a |
| <a name="module_test-cluster"></a> [test-cluster](#module\_test-cluster) | ./modules/GKE | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_binding.cloudsql_client](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.logging_logWriter](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_service_account.service_acc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

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