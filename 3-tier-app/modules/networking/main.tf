
### VPC Creation
resource "aws_vpc" "main_vpc" {
    cidr_block = var.vpc_cidr
    tags = var.tags
    enable_dns_hostnames = true
    enable_dns_support = true
}

data "aws_availability_zones" "available" {
    state = "available"
}
#### Public Subnets Creation
resource "aws_subnet" "public_subnet" {
    count = var.public_sn_count
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
    availability_zone = data.aws_availability_zones.available.all_availability_zones[count.index]
    map_public_ip_on_launch = true
    tags = var.tags
  
}
##IGW Creation
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main_vpc.id
    tags = var.tags
}
## Public Route Table Creation
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main_vpc.id
    tags = var.tags
}
resource "aws_route" "public_route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "public_rt_assoc" {
    count = var.public_sn_count
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id
}

### Nat Gateway Creation
resource "aws_eip" "nat_eip" {
    vpc = true
    tags = var.tags
  
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet[0].id
}
## Private Subnets Creation
resource "aws_subnet" "private_subnets" {
  count = var.private_sn_count
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index + var.private_sn_count)
  availability_zone = data.aws_availability_zones.available.all_availability_zones[count.index]
  tags = var.tags
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = var.tags
}
resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}
resource "aws_route_table_association" "private_rt_assoc" {
  count = var.private_sn_count
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}