provider "aws" {
  region = "eu-west-3"
}

resource "aws_ecs_cluster" "ecs" {
  name = var.ecs_name
}

resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
}

module "vpc" {
  source = "../../networking/vpc/"

  client_name                = var.client_name
  environment                = var.environment
  vpc_cidr                   = var.vpc_cidr
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  availability_zones         = var.availability_zones

  key_name   = "bastion_key"
  public_key = tls_private_key.bastion_key.public_key_openssh
}

module "asg" {
  source = "../asg"

  cluster_name  = var.cluster_name

  ami           = "ami-027cb17c7467f3c2e"
  instance_type = "t2.micro"

  min_size           = 1
  max_size           = 4
  enable_autoscaling = true

  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnets

  tags = {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "wordpress" {
  name = "wordpress"
  
  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.asg.asg_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }
}
