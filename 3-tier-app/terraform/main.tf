locals {
    project_name = "3-tier-app"
    region       = "us-west-2"
    vpc_cidr     = "10.0.0.0/16"
    env = "dev"
}
provider "aws" {
  region=local.region 
}
