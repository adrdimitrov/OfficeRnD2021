variable "bucket_name" {
  default     = "terraform-up-and-running-state-v1"
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
}

variable "table_name" {
  default     = "terraform-up-and-running-locks"
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
}
