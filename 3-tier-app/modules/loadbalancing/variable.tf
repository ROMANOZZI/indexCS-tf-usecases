variable "lb_sg" {}
variable "backend_lb_sg" {
  
}
variable "private_subnet_ids" {
  type = set(string)
}
variable "public_subnet_ids" {
  type=set(string)
}
variable "listener_port" {
  type = number
}
variable "listener_protocol" {
  type = string
}
variable "azs" {
  type=set(string)
}
variable "frontend_tg" {
}
variable "backend_tg" {
  
}
variable "certificate_arn"{
    type="string"
}
variable "" {
  
}