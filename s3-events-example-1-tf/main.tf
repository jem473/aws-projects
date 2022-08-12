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
}

variable "destination_bucket_name" {
  type = string
  description = "The name for the destination bucket; must follow S3 bucket naming rules."
}

variable "filter_suffix" {
  type = string
  default = ".flac"
}

variable "lambda_filename" {
  type = string
  description = "The filename of the Lambda .zip file."
}

variable "ffmpeg_layer_filename" {
  type = string
  description = "The filename of the Lambda layer .zip file."
}

variable "lambda_memory" {
  type = number
  default = 1024
}

variable "lambda_ephemeral_storage" {
  type = number
  default = 512
}

variable "lambda_timeout" {
  type = number
  default = 120
}

variable "region" {
  type = string
  default = "us-east-1"
}