provider "aws" {
    region = "us-east-2"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "az" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "key_pair" {}
variable "my_pub_key_location" {}
resource "aws_vpc" "DevOps_VPC" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

resource "aws_subnet" "DevOps_SUBNET" {
    vpc_id = aws_vpc.DevOps_VPC.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.az
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }  
} 

resource "aws_internet_gateway" "DevOps_IGW" {
    vpc_id = aws_vpc.DevOps_VPC.id
    tags = {
      "Name" = "${var.env_prefix}-igw"
    }
}

/*resource "aws_route_table" "DevOps_RTB" {
    vpc_id = aws_vpc.DevOps_VPC.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.DevOps_IGW.id      
    } 
    tags = {
      "Name" = "${var.env_prefix}-rtb"
    }
}*/

/*resource "aws_route_table_association" "AS_RTB" {
  subnet_id = aws_subnet.DevOps_SUBNET.id
  route_table_id = aws_route_table.DevOps_RTB.id
}*/


resource "aws_default_route_table" "DevOps_MAIN_RTB" {
  default_route_table_id = aws_vpc.DevOps_VPC.default_route_table_id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.DevOps_IGW.id      
    } 
    tags = {
      "Name" = "${var.env_prefix}-main-rtb"
    }
}
resource "aws_default_security_group" "default" {
    vpc_id = aws_vpc.DevOps_VPC.id

    ingress {
        description = "ALLOW SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = [var.my_ip]
    }
    ingress {
        description = "ALLOW to nginx"
        from_port        = 8080
        to_port          = 8080
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    
    egress {
        description = "ALLOW ALL"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = {
      "Name" = "${var.env_prefix}-sg"
    }
}

data "aws_ami" "latest_amazon_linux" {
    most_recent = true
    owners = ["137112412989"]
    filter {
      name = "name"
      values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
}
resource "aws_key_pair" "ssh_key" {
    key_name = "devops_key_server"
    public_key = "${file(var.my_pub_key_location)}"
}
resource "aws_instance" "DevOps_SERVER" {
    ami = data.aws_ami.latest_amazon_linux.id
    instance_type = var.instance_type
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_default_security_group.default.id]
    availability_zone = var.az
    subnet_id = aws_subnet.DevOps_SUBNET.id
    key_name = aws_key_pair.ssh_key.key_name
    tags = {
      "Name" = "${var.env_prefix}-server-1"
    }
}

output "ec2_public_ip" {
    value = aws_instance.DevOps_SERVER.public_ip
}