locals {
  cur_report_name = var.name
  cur_s3_prefix   = "cur"
  cur_report_arn  = "arn:${data.aws_partition.current.partition}:cur:${data.aws_s3_bucket.s3_bucket.region}:${data.aws_caller_identity.current.account_id}:definition/*"
}
