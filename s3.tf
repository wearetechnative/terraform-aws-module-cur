module "cur_s3" {
  source = "git@github.com:TechNative-B-V/terraform-aws-module-s3.git?ref=44279e0b8bdc34327d87781d031bbb7468cefd23"

  name                             = var.override_s3_fixed_name != null ? var.override_s3_fixed_name : var.name
  use_fixed_name = var.override_s3_fixed_name != null ? true : false
  kms_key_arn                      = var.kms_key_arn
  bucket_policy_addition           = jsondecode(data.aws_iam_policy_document.costandusagereport_s3_access.json)
  disable_encryption_enforcement   = true
  source_replication_configuration = var.s3_source_replication_configuration
  lifecycle_configuration          = var.lifecycle_rules_configuration
}

data "aws_iam_policy_document" "costandusagereport_s3_access" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy"
    ]

    resources = [module.cur_s3.s3_arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.id]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [local.cur_report_arn]
    }
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = ["${module.cur_s3.s3_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.id]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [local.cur_report_arn]
    }
  }
}
