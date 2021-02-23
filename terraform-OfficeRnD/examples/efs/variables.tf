# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS FOR VPC module
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

/*variable "environment" {
  description = "The name of the environment we're deploying to"
  type        = string
}

variable "client_name" {
  description = "The name of the VPC we are deploying in"
  type        = string
}
*/
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

