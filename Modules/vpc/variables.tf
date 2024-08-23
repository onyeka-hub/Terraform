# These are vpc submodules variables
variable "vpc_cidr" {
  type        = string
  description = "vpc cidr block IP, this will depend on the environment chosen"

}

variable "enable_dns_support" {
  type        = bool
  description = "This help vpc to allow vpc dns support"
  # default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "This help vpc to allow vpc dns hostname support"
  # default     = true
}

variable "access_ip" {
  type        = string
  description = "It represents all possible IP addresses in IPv4, meaning it matches any IP address."
  # default     = "0.0.0.0/0"
}


variable "preferred_number_of_public_subnets" {
  type        = number
  description = "This helps in setting the total number of public subnets to be created"
  # default     = 2
}

variable "preferred_number_of_private_subnets" {
  type        = number
  description = "This helps in setting the total number of private subnets to be created"
  # default     = 2
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  #default     = {}
}

variable "name" {
  type        = string
  description = "name to be attached to resources"
  # default     = "STDP"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet cidrs"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet cidrs"
}

variable "environment" {
  type        = string
  description = "Infrastructure environment. eg. sandbox/development, prod, staging etc"
}

