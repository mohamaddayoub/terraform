provider "aws" {
    region = "us-east-2"
}

resource "aws_vpc" "DevOps_VPC" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

module "devops_subnet" {
    source = "./modules/subnet"
    vpc_id = aws_vpc.DevOps_VPC.id
    subnet_cidr_block = var.subnet_cidr_block
    az = var.az
    env_prefix = var.env_prefix
    default_route_table_id = aws_vpc.DevOps_VPC.default_route_table_id
}



module "devops_webserver" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.DevOps_VPC.id
    my_ip = var.my_ip
    env_prefix = var.env_prefix
    my_pub_key_location = var.my_pub_key_location
    instance_type = var.instance_type
    az = var.az 
    image_name = var.image_name
    subnet_id = module.devops_subnet.subnet.id
}



