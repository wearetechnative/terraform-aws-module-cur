variable "name" {
  description = "Name for Athena CUR."
  type        = string
}

variable "override_s3_fixed_name" {
  description = "Set this variable in case of existing S3 bucket that should not be renamed because of current data. Generally for pre-provisioned accounts."
  type = string
  default = null
}

variable "kms_key_arn" {
  description = "KMS key to use for encrypting RDS instances."
  type        = string
}

variable "s3_source_replication_configuration" {
  description = "Replication target configuration using this bucket as source. The key of the map is used for naming. This is passed to the S3 module."
  type = map(object({
    destination_bucket_arn  = string
    destination_aws_account = string
    destination_kms_key_arn = string
  }))
  default = {}
}

variable "overwrite_report" {
  description = "Internal use. Overwrite report on new updates."
  type        = bool
  default     = true
}

variable "additional_artifacts" {
  description = "Internal use. Add additional artifacts for different systems. Optional array which includes values ATHENA, REDSHIFT."
  type        = list(string)
  default     = ["ATHENA"]
}

variable "format" {
  description = "Internal use. Format to store files, currently supports Parquet or textORcsv."
  type        = string
  default     = "Parquet"
}

variable "lifecycle_rules_configuration" {
  description = "Object Lifecycle rules configuration."
  type = map(object({
    status = string
    bucket_prefix = string
    transition = object({
      storage_class = string
      transition_days = number
    })
    expiration_days = number
    noncurrent_version_expiration = object({
        newer_noncurrent_versions = number
        noncurrent_days = number
    })
    noncurrent_version_transition = object({
        newer_noncurrent_versions = number
        noncurrent_days = number
        storage_class = string
    })
  }))
  default = {}
}
