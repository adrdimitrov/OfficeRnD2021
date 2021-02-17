provider "aws" {
  region = "eu-west-3"
}

terraform {
  backend "s3" {

    bucket         = "terraform-up-and-running-state-v1"
    key            = "live/stage/data-stores/mysql/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "mysql" {
  source = "../../../../modules/data-stores/mysql/"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}
