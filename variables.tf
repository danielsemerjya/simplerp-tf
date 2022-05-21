variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "eu-central-1"
}

variable "stage_name" {
  description = "AWS ApiGw stage name"
  type        = string
  default     = "dev"
}

variable "aws_account_id" {
  description = "AWS account id"
  type        = string
  sensitive   = true
}
