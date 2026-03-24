variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
    validation {
        condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$", var.vpc_cidr))
        error_message = "The VPC CIDR block must be a valid IPv4 CIDR address."
    }
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