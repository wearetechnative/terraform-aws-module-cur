# Terraform AWS [cur]

This module implements Cost and Usage reports in AWS which includes the S3 bucket.

## Todo

Lifecycle rules as these S3 buckets can grow quite large.

[![](we-are-technative.png)](https://www.technative.nl)

## How does it work

### First use after you clone this repository or when .pre-commit-config.yaml is updated

Run `pre-commit install` to install any guardrails implemented using pre-commit.

See [pre-commit installation](https://pre-commit.com/#install) on how to install pre-commit.

## Usage

Basic usage works like below which includes a demonstration of setting up the target in an S3 replication setup.

```hcl
module "cur" {
  providers = {
    aws = aws.us-east-1
  }

  # source = "git@github.com:TechNative-B-V/modules-aws.git?ref=v1.1.8"
  source = "./modules/cur/"

  name        = local.cur_athena_name
  kms_key_arn = module.kms.kms_key_arn

  s3_source_replication_configuration = {
    "cur" : {
      destination_bucket_arn  = var.finops_replication_bucket_configuration.destination_bucket_arn
      destination_aws_account = aws_organizations_account.finops.id
      destination_kms_key_arn = var.finops_replication_bucket_configuration.destination_kms_key_arn
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=4.13.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cur_s3"></a> [cur\_s3](#module\_cur\_s3) | git@github.com:TechNative-B-V/terraform-aws-module-s3.git | 63556b762f684a50af2491294770ae5db731c46f |

## Resources

| Name | Type |
|------|------|
| [aws_cur_report_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cur_report_definition) | resource |
| [aws_arn.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.costandusagereport_s3_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_artifacts"></a> [additional\_artifacts](#input\_additional\_artifacts) | Internal use. Add additional artifacts for different systems. Optional array which includes values ATHENA, REDSHIFT. | `list(string)` | <pre>[<br>  "ATHENA"<br>]</pre> | no |
| <a name="input_format"></a> [format](#input\_format) | Internal use. Format to store files, currently supports Parquet or textORcsv. | `string` | `"Parquet"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key to use for encrypting RDS instances. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for Athena CUR. | `string` | n/a | yes |
| <a name="input_override_s3_fixed_name"></a> [override\_s3\_fixed\_name](#input\_override\_s3\_fixed\_name) | Set this variable in case of existing S3 bucket that should not be renamed because of current data. Generally for pre-provisioned accounts. | `string` | `null` | no |
| <a name="input_overwrite_report"></a> [overwrite\_report](#input\_overwrite\_report) | Internal use. Overwrite report on new updates. | `bool` | `true` | no |
| <a name="input_s3_source_replication_configuration"></a> [s3\_source\_replication\_configuration](#input\_s3\_source\_replication\_configuration) | Replication target configuration using this bucket as source. The key of the map is used for naming. This is passed to the S3 module. | <pre>map(object({<br>    destination_bucket_arn  = string<br>    destination_aws_account = string<br>    destination_kms_key_arn = string<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cur_s3_arn"></a> [cur\_s3\_arn](#output\_cur\_s3\_arn) | n/a |
| <a name="output_cur_s3_bucket_name"></a> [cur\_s3\_bucket\_name](#output\_cur\_s3\_bucket\_name) | n/a |
| <a name="output_cur_s3_bucket_replication_source_configuration"></a> [cur\_s3\_bucket\_replication\_source\_configuration](#output\_cur\_s3\_bucket\_replication\_source\_configuration) | test |
| <a name="output_cur_s3_bucket_replication_target_configuration"></a> [cur\_s3\_bucket\_replication\_target\_configuration](#output\_cur\_s3\_bucket\_replication\_target\_configuration) | n/a |
<!-- END_TF_DOCS -->
