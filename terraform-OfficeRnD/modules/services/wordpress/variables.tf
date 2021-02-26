# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "The name of the environment we're deploying to"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  type        = string
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
}

variable "client_name" {
  description = "The name of the VPC we are deploying in"
  type        = string
  default     = "example"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  type        = list
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
  type        = list
  description = "List of availability zones"
}

variable "create_key_pair" {
  description = "Controls if key pair should be created"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "The name for the key pair."
  type        = string
  default     = Bastion
}

variable "public_key" {
  description = "The public key material."
  type        = string
  default     = ""
}

# database name, username and password for rds mysql
variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "Pa$$word"
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "wordpress"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "wordpress"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami" {
  description = "The AMI to run in the cluster"
  type        = string
  default     = "ami-027cb17c7467f3c2e"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "identifier_prefix" {
  description = "The identifier_prefix for the db"
  type        = string
  default     = "wordpress"
}

#------------------------------------------------------------------------------
# Variables for EFS Module
#------------------------------------------------------------------------------
variable "encrypted" {
  description = "If true, the file system will be encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "If set, use a specific KMS key"
  type        = string
  default     = null
}

variable "efs_inbound_ips" {
  description = "Inbound ips that will be opened for communication with ecs instances"
  type        = string
  default     = "10.0.0.0/16"
}

