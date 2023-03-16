data "aws_arn" "s3_bucket" {
  arn = module.cur_s3.s3_arn
}

data "aws_s3_bucket" "s3_bucket" {
  bucket = data.aws_arn.s3_bucket.resource
}

# requires region us-east-1
resource "aws_cur_report_definition" "this" {
  report_name                = local.cur_report_name
  additional_schema_elements = ["RESOURCES"] # tick: Include resource IDs
  refresh_closed_reports     = true          # tick: Automatically refresh your Cost & Usage Report when changes are detected for previous months with closed bills.

  s3_bucket = data.aws_s3_bucket.s3_bucket.id
  s3_region = data.aws_s3_bucket.s3_bucket.region

  s3_prefix            = local.cur_s3_prefix
  time_unit            = "HOURLY"
  report_versioning    = var.overwrite_report ? "OVERWRITE_REPORT" : "CREATE_NEW_REPORT" # required value vor ATHENA
  additional_artifacts = var.additional_artifacts
  compression          = var.format == "Parquet" ? "Parquet" : (var.format == "textORcsv" ? "GZIP" : null /* not implemented*/)
  format               = var.format

  depends_on = [
    module.cur_s3
  ]
}
