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
#             VPC PARAMETERS
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
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "List of public subnet CIDR blocks"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  type        = list
}

variable "private_subnet_cidr_blocks" {
  description = "List of private subnet CIDR blocks"
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  type        = list
}

variable "availability_zones" {
  description = "List of availability zones"
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
  type        = list
}

variable "create_key_pair" {
  description = "Controls if key pair should be created"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "The name for the key pair."
  type        = string
  default     = "Bastion"
}

variable "public_key" {
  description = "The public key material."
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
#             ALB PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "alb_name" {
  description = "The name of the ALB and all its resources"
  type        = string
  default     = "Wordpress-ALB"
}
