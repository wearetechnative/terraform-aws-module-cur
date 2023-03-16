output "cur_s3_arn" {
  value = module.cur_s3.s3_arn
}

output "cur_s3_bucket_name" {
  value = data.aws_s3_bucket.s3_bucket.id
}

output "cur_s3_bucket_replication_target_configuration" {
  value = module.cur_s3.replication_target_bucket_arguments
}

# test
output "cur_s3_bucket_replication_source_configuration" {
  value = module.cur_s3.replication_source_bucket_arguments
}
