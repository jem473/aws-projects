resource "aws_dms_replication_instance" "replication_instance" {
    allocated_storage = var.replication_instance_allocated_storage
    availability_zone = var.replication_instance_availability_zone
    multi_az = var.replication_instance_multi_az
    preferred_maintenance_window = var.replication_instance_preferred_maintenance_window
    replication_instance_class = var.replication_instance_class
    replication_instance_id = var.replication_instance_id
    apply_immediately = var.replication_instance_apply_changed_immediately
    auto_minor_version_upgrade = var.replication_instance_auto_minor_version_upgrade
    kms_key_arn = var.dms_kms_key_arn
    replication_subnet_group_id = var.replication_subnet_group_id

    publicly_accessible = true
}

resource "aws_iam_role" "dms_access_for_endpoint" {
    name = "dms_access_for_endpoint"
    assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
}

data "aws_iam_policy_document" "dms_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            identifiers = ["dms.amazonaws.com"]
            type = "Service"
        }
    }
}

resource "aws_iam_policy" "dms_dynamodb_access_policy" {
    name = "DMSDynamoDBAccessPolicy"
    policy = data.aws_iam_policy_document.dms_dynamodb_access_policy_document.json
}

data "aws_iam_policy_document" "dms_dynamodb_access_policy_document" {
    statement {
        actions = [
            "dynamodb:PutItem",
            "dynamodb:CreateTable",
            "dynamodb:DescribeTable",
            "dynamodb:DeleteTable",
            "dynamodb:DeleteItem",
            "dynamodb:UpdateItem"
        ]
        resources = ["arn:aws:dynamodb:us-west-2:account-id:table/*"] # Modify?
    }

    statement {
        actions = ["dynamodb:ListTables"]
        resources = ["*"]
    }
}

resource "aws_iam_role_policy_attachment" "dms_dynamodb_access_policy_attach" {
    role = aws_iam_role.dms_access_for_endpoint.name
    policy_arn = aws_iam_policy.dms_dynamodb_access_policy.arn
}

resource "aws_iam_role" "dms_cloudwatch_logs_role" {
    name = "dms-cloudwatch-logs-role"
    assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
}

resource "aws_iam_role_policy_attachment" "dms_cloudwatch_logs_role_attachment" {
    role = aws_iam_role.dms_cloudwatch_logs_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
}

resource "aws_iam_role" "dms_vpc_role" {
    name = "dms_vpc_role"
    assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
}

resource "aws_iam_role_policy_attachment" "dms_vpc_role_attach" {
    role = aws_iam_role.dms_vpc_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
}