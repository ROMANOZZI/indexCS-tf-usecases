locals {
    project_name = "Al-Naboodah"
    region       = "us-west-2"
    vpc_cidr     = "10.0.0.0/16"
    env = "dev"
    directory_name = "corp.notexample.com"
}
provider "aws" {
  region=local.region 
   shared_credentials_files = ["C:/Users/moham/.aws/credentials"]
   profile = "ICS" 
   
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
resource "aws_directory_service_directory" "Al-Naboodah_directory" {
  name     = local.directory_name
  password = "SuperSecretPassw0rd"
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = aws_vpc.main.id
    subnet_ids = module.networking.private_subnet_ids
  }

  tags = {
    Project = local.project_name
  }
}
