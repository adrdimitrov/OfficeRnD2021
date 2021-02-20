# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name of the ASG and all its resources"
  type        = string
  default     = "Wordpress-ASG"
}

# --------------------------------------------------------------------------------------------------------------------


variable "environment" {
  description = "The name of the environment we're deploying to"
  type        = string
  default     = "example"
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
  default     = null
}

variable "public_key" {
  description = "The public key material."
  type        = string
  default     = ""
}
