variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
  
}
variable "tags" {
    description = "Tags to apply to resources"
    type        = map(string)
  
}
variable "public_sn_count" {
  description = "number of public subnets"
  type = number
}
variable "private_sn_count" {
    description = "number of private subnets"
    type = number
}