#variables for sandbox environment

variable "region" {
  description = "aws region where resources are created"
  type        = string
}

# ################################################################
# # vpc variables 
# ################################################################
variable "vpc_cidr" {
  type        = string
  description = "vpc cidr block IP, this will depend on the environment chosen when creating resources"
}

variable "enable_dns_support" {
  type        = bool
  description = "This help vpc to allow vpc dns support"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "This help vpc to allow vpc dns hostname support"
}

variable "access_ip" {
  type        = string
  description = "It represents all possible IP addresses in IPv4, meaning it matches any IP address."
}


variable "preferred_number_of_public_subnets" {
  type        = number
  description = "This helps in setting the total number of public subnets to be created"
}

variable "preferred_number_of_private_subnets" {
  type        = number
  description = "This helps in setting the total number of private subnets to be created"
}

variable "name" {
  type        = string
  description = "name to be attached to resources"
}

variable "environment" {
  type        = string
  description = "Infrastructure environment. eg. sandbox/development, prod, staging etc"
}
