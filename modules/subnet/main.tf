resource "aws_subnet" "DevOps_SUBNET" {
    vpc_id = var.vpc_id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.az
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }  
} 

resource "aws_internet_gateway" "DevOps_IGW" {
    vpc_id = var.vpc_id
    tags = {
      "Name" = "${var.env_prefix}-igw"
    }
}


resource "aws_default_route_table" "DevOps_MAIN_RTB" {
  default_route_table_id = var.default_route_table_id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.DevOps_IGW.id      
    } 
    tags = {
      "Name" = "${var.env_prefix}-main-rtb"
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