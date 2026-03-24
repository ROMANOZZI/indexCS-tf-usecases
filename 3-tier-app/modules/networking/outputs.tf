output "vpc_id" {
  value = aws_vpc.vpc_main.id
}

output "public_subnet_ids" {
  value = aws_subnet.sn_pub[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.sn_pri[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.ngw_main.id
}
