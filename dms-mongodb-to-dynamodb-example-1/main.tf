terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.25.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type = string
  default = "us-east-1"
  description = "The region in which the S3 buckets will be created and the Lambda function will be executed."
}