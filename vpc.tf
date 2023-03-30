variable "vpc_cidr_block" {}
variable "private_subnets_cidr_block" {}
variable "public_subnets_cidr_block" {}


provider "aws" {
    region = "us-east-2"
  }

data "aws_availability_zones" "azs" {}

module "myapp_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  name = "myapp_vpc"
  cidr = var.vpc_cidr_block

  azs = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnets_cidr_block
  public_subnets = var.public_subnets_cidr_block

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true  


  tags = {
    "kubernetes.io/cluster/myapp_eks_cluster" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/myapp_eks_cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/myapp_eks_cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}
