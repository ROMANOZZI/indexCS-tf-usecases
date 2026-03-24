### VPC Creation
resource "aws_vpc" "vpc_main" {
    cidr_block = var.vpc_cidr
    tags = var.tags
    enable_dns_hostnames = true
    enable_dns_support = true
    
}

data "aws_availability_zones" "available" {
    state = "available"
}

#### Public Subnets Creation
resource "aws_subnet" "sn_pub" {
    count = var.public_sn_count
    vpc_id = aws_vpc.vpc_main.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
    tags = var.tags
  
}

## IGW Creation
resource "aws_internet_gateway" "igw_main" {
    vpc_id = aws_vpc.vpc_main.id
    tags = var.tags
}

## Public Route Table Creation
resource "aws_route_table" "rt_pub" {
    vpc_id = aws_vpc.vpc_main.id
    tags = var.tags
}

resource "aws_route" "route_pub" {
    route_table_id = aws_route_table.rt_pub.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_main.id
}

resource "aws_route_table_association" "rt_pub_assoc" {
    count = var.public_sn_count
    subnet_id = aws_subnet.sn_pub[count.index].id
    route_table_id = aws_route_table.rt_pub.id
}

### Nat Gateway Creation
resource "aws_eip" "eip_nat" {
   
    tags = var.tags
}

resource "aws_nat_gateway" "ngw_main" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.sn_pub[0].id
  tags          = var.tags
}

## Private Subnets Creation
resource "aws_subnet" "sn_pri" {
  count = var.private_sn_count
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + var.public_sn_count)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = var.tags
}

resource "aws_route_table" "rt_pri" {
  vpc_id = aws_vpc.vpc_main.id
  tags = var.tags
}

resource "aws_route" "route_pri" {
  route_table_id         = aws_route_table.rt_pri.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw_main.id
}

resource "aws_route_table_association" "rt_pri_assoc" {
  count = var.private_sn_count
  subnet_id = aws_subnet.sn_pri[count.index].id
  route_table_id = aws_route_table.rt_pri.id
}
