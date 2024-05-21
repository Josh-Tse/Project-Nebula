variable "lambda-image-uri" {
  type        = string
  description = "all lambda funtions image link"
  default     = "us-east-1"
}

variable "aws-account-ID" {
  description = "AWS account ID"
  type        = string
}

variable "my-region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}