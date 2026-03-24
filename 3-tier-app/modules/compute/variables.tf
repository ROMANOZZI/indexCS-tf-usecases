variable "instance_type"{
    description = "Instance type for the frontend tier"
    type        = string
    default     = "t2.micro"
}  
variable "backend_instance_type"{
    description = "Instance type for the backend tier"
    type        = string
    default     = "t2.micro"
}  
variable "frontend_app_sg" {
    description = "Security group for the frontend application"
    type        = string
  
}
variable "backend_app_sg" {
    description = "Security group for the backend application"
    type        = string
  
}

variable "minimum_instance_number" {
  description = "the minimum number of instances for each tier"
  type = number
}
variable "maximum_instance_number" {
  description = "the maximum number of instances for each tier"
  type = number
}
variable "desired_instance_number" {
  description = "the desired number of instances for each tier"
  type = number
}
variable "key_name" {
    description = "the name of the key pair to use for the instances"
    type = string
  
}
variable "lb_tg_name" {
    description = "the name of the load balancer target group for the frontend"
    type = string
  
}
variable "backend_lb_tg_name" {
    description = "the name of the load balancer target group for the backend"
    type = string
  
}
variable "private_subnet_ids" {
    description = "List of private subnet IDs for the auto scaling group"
    type        = list(string)
  
}
variable "public_subnet_ids" {
    description = "List of public subnet IDs for the load balancer"
    type        = list(string)
  
}
variable "image_id" {
    description = "the ID of the AMI to use for the instances"
    type        = string
  
}
variable "vpc_id" {
    description = "the ID of the VPC where the resources will be created"
    type        = string
  
}
variable "private_subnets" {
    description = "List of private subnet IDs for the auto scaling group"
    type        = list(string)
  
}