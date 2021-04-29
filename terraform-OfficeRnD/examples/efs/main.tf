provider "aws" {
  region = "eu-west-3"

}

module "vpc" {
  source = "../../modules/networking/vpc/"

  client_name                = "test"
  environment                = "dev"
  vpc_cidr                   = var.vpc_cidr
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  availability_zones         = var.availability_zones

  key_name   = var.key_name
}

module "efs" {
  source                 = "../../modules/data-stores/efs/"
 
  efs_name               = "efs"
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnets
  efs_inbound_ips        = ["10.0.0.0/16"]
}
