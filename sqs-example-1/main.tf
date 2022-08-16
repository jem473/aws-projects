terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.26.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type = string
  default = "us-east-1"
  description = "The region resources will be created in."
}

variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
    description = "The CIDR block to use for the testing VPC."
}

variable "ssh_allow_cidr_blocks" {
    type = list(string)
    default = ["0.0.0.0/0"]
}