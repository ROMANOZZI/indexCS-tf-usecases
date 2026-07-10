locals {
    project_name = "3-tier-app"
    region       = "us-west-2"
    vpc_cidr     = "10.0.0.0/16"
    env = "dev"
}
provider "aws" {
  region=local.region 
   shared_credentials_files = ["C:/Users/moham/.aws/credentials"]
   profile = "vscode" 
   
}
module "networking" {
  source = "../modules/networking"
  vpc_cidr = local.vpc_cidr
  public_sn_count = 2
  private_sn_count = 2
  tags = {
    Project = local.project_name
    Environment = local.env
  }
  
}