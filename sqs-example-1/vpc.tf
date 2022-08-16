resource "aws_vpc" "testing_vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "sqs_testing_vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.testing_vpc.id
  cidr_block = "10.0.${10+count.index}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  map_public_ip_on_launch = true
  enable_resource_name_dns_a_record_on_launch = true
  private_dns_hostname_type_on_launch = "ip-name"

  tags = {
    Name = "public_testing_${data.aws_availability_zones.available.names[count.index]}"
  }
}

/*
resource "aws_vpc_endpoint" "sqs_endpoint" {
  vpc_id = aws_vpc.testing_vpc.id
  service_name = "com.amazonaws.${region}.sqs"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  ip_address_type = "ipv4"
  subnet_ids = [for subnet in aws_subnet.public_subnet : subnet => subnet.id]
}
*/

resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.testing_vpc.id
  
  name = "testing_allow_ssh"
  description = "Allow inbound SSH."

  ingress {
    description = "Allow SSH from specified CIDR blocks."
    protocol = "tcp"
    from_port = 22
    to_port = 22
    
    cidr_blocks = var.ssh_allow_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}