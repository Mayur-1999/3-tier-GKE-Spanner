## Terraform Infrastructure
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.68.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_Dev"></a> [Dev](#module\_Dev) | ./Env/Dev | n/a |
| <a name="module_prod"></a> [prod](#module\_prod) | ./Env/prod | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_env"></a> [deployment\_env](#input\_deployment\_env) | n/a | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-central1a"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->