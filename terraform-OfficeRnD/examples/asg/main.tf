provider "aws" {
  region = "eu-west-3"

}
/*
terraform {
  backend "s3" {

    bucket         = "terraform-up-and-running-state-v1"
    key            = "example/asg/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
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

module "alb" {
  source = "../../modules/networking/alb"

  alb_name   = var.alb_name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
}

module "asg" {
  source = "../../modules/cluster/asg"

  cluster_name  = var.cluster_name

  ami           = "ami-027cb17c7467f3c2e"
  instance_type = "t2.micro"

  min_size           = 1
  max_size           = 4
  enable_autoscaling = true

  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnets
  inbound_ips       = module.alb.alb_security_group_id
}
