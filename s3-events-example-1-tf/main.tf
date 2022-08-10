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
}

variable "destination_bucket_name" {
  type = string
}

variable "filter_suffix" {
  type = string
  default = ".flac"
}

variable "lambda_filename" {
  type = string
}

variable "ffmpeg_layer_filename" {
  type = string
}

variable "lambda_memory" {
  type = number
  default = 1024
}

variable "lambda_timeout" {
  type = number
  default = 120
}

variable "region" {
  type = string
  default = "us-east-1"
}