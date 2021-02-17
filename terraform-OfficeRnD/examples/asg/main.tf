provider "aws" {
  region = "eu-west-3"

}

terraform {
  backend "s3" {

    bucket         = "terraform-up-and-running-state-v1"
    key            = "example/asg/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "asg" {
  source = "../../modules/cluster/asg"

  cluster_name  = var.cluster_name

  ami           = "ami-027cb17c7467f3c2e"
  instance_type = "t2.micro"

  min_size           = 1
  max_size           = 4
  enable_autoscaling = true

  subnet_ids        = data.aws_subnet_ids.default.ids
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
