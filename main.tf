provider "aws" {}

variable "cidr_block_vpc" {
    description = "cidr block for ur VPC"
}
variable "environment" {
    description = "Dev environment"
}
variable az {}
resource "aws_vpc" "DevOps_VPC" {
    cidr_block = "10.0.0.0/16"
    tags = {
    Name = var.environment
  }
}

resource "aws_subnet" "DevOps_SUBNET" {
    vpc_id = aws_vpc.DevOps_VPC.id
    cidr_block = var.cidr_block_vpc
    availability_zone = var.az
    tags = {
    Name = "DevOps_SUBNET"
  }
    
}

output "DevOps_VPC" {
    value = aws_vpc.DevOps_VPC.id
}
output "DevOps_SUBNET" {
    value = aws_subnet.DevOps_SUBNET.id
    
} 