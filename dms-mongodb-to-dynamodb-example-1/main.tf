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
  description = "The region in which the replication instance will be created."
}

variable "replication_instance_availability_zone" {
  type = string
  default = null
}

variable "replication_instance_multi_az" {
  type = bool
  default = false
}

variable "replication_instance_apply_changed_immediately" {
  type = bool
  default = true
}

variable "replication_instance_auto_minor_version_upgrade" {
  type = bool
  default = true
}

variable "replication_instance_preferred_maintenance_window" {
  type = string
  default = "sun:09:00-sun:11:00"
}

variable "replication_instance_class" {
  type = string
  default = "dms.t2.micro"
}

variable "replication_instance_id" {
  type = string
  default = "mongodb-to-dynamodb-test"
}

variable "dms_engine_version" {
  type = string
  default = "3.1.4"
}

variable "dms_kms_key_arn" {
  type = string
  default = null
}

variable "replication_subnet_group_id" {
  type = string
  default = null
}

variable "replication_instance_allocated_storage" {
  type = number
  default = 8
}