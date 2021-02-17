provider "aws" {
  region = "eu-west-3"

}

terraform {
  backend "s3" {

    bucket         = "terraform-up-and-running-state-v1"
    key            = "live/stage/services/wordpress/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "wordpress" {

  source = "../../../../modules/services/wordpress"

  environment            = var.environment
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false
}
