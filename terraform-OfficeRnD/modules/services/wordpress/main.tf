resource "tls_private_key" "bastion_key" {
  algorithm = "RSA"
}

module "wordpress-db" {
  source = "../../data-stores/mysql"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
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
  source = "../../cluster/asg"

  cluster_name  = "wordpress-${var.environment}"
  ami           = var.ami
  instance_type = var.instance_type

  min_size           = var.min_size
  max_size           = var.max_size
  enable_autoscaling = var.enable_autoscaling

  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnets
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  inbound_ips       = module.alb.alb_security_group_id
}

module "alb" {
  source = "../../networking/alb"

  alb_name   = "wordpress-${var.environment}"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
}

// data "template_file" "user_data" {
//  template = file("${path.module}/user-data.sh")
//
//  vars = {
//    server_port = var.server_port
//    db_address  = data.terraform_remote_state.db.outputs.address
//    db_port     = data.terraform_remote_state.db.outputs.port
//    server_text = var.server_text
//  }
//}

resource "aws_lb_target_group" "asg" {
  name     = "wordpress-${var.environment}"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = "eu-west-3"
  }
}

