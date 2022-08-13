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

variable "source_bucket_name" {
  type = string
  description = "The name for the source bucket; must follow S3 bucket naming rules."
  nullable = false
}

variable "destination_bucket_name" {
  type = string
  description = "The name for the destination bucket; must follow S3 bucket naming rules."
  nullable = false
}

variable "filter_suffix" {
  type = string
  default = ".flac"
  description = "The suffix to filter on for the S3 Event notification."
}

variable "lambda_filename" {
  type = string
  description = "The filename of the Lambda .zip file."
  nullable = false
}

variable "ffmpeg_layer_filename" {
  type = string
  description = "The filename of the Lambda layer .zip file."
  nullable = false
}

variable "lambda_memory" {
  type = number
  default = 1024
  description = "Memory to allocate to the Lambda function, in MB."
}

variable "lambda_ephemeral_storage" {
  type = number
  default = 512
  description = "Ephemeral storage to allocate to the Lambda function, in MB."
}

variable "lambda_timeout" {
  type = number
  default = 120
  description = "The timeout for the Lambda function, in seconds."
}

variable "region" {
  type = string
  default = "us-east-1"
  description = "The region in which the S3 buckets will be created and the Lambda function will be executed."
}