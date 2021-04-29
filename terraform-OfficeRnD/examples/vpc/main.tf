provider "aws" {
  region = "eu-west-3"

}
/*
resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
}
*/
module "vpc" {
  source = "../../modules/networking/vpc/"

  client_name                = var.client_name
  environment                = var.environment
  vpc_cidr                   = var.vpc_cidr
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  availability_zones         = var.availability_zones

  key_name   = var.key_name
}
