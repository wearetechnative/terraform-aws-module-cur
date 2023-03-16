module "cur_s3" {
  source = "git@github.com:TechNative-B-V/terraform-aws-module-s3.git?ref=d23eda80e3de956f30f176fc1f2e0cdfa3ac3ae8"

  name                             = var.name
  kms_key_arn                      = var.kms_key_arn
  bucket_policy_addition           = jsondecode(data.aws_iam_policy_document.costandusagereport_s3_access.json)
  disable_encryption_enforcement   = true
  source_replication_configuration = var.s3_source_replication_configuration
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