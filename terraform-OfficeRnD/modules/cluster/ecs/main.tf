provider "aws" {
  region = "eu-west-3"
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

module "alb" {
  source = "../../networking/alb"

  alb_name   = var.alb_name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
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

  inbound_ips       = module.alb.alb_security_group_id

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

resource "aws_ecs_cluster" "ecs" {
  name = var.ecs_name
}

data "aws_iam_role" "ecs_role" {
  name = "AWSServiceRoleForECS"
}


resource "aws_ecs_service" "ecs-wordpress" {
  name            = var.ecs_name
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = 2
  iam_role        = "AWSServiceRoleForECS"
#  depends_on      = ["AmazonECSServiceRolePolicy"]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = module.alb.alb_arn
    container_name   = "wordpress"
    container_port   = 80 
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

resource "template_file" "wordpress-container" {
  template = "${file("task-definitions/wordpress.json")}"
}

resource "aws_ecs_task_definition" "wordpress" {
    family                = "wordpress"
    container_definitions = "${template_file.wordpress-container.rendered}"
}
