# module for creating the vpc
module "vpc" {
  source                              = "../../Modules/VPC"
  vpc_cidr                            = var.vpc_cidr
  environment                         = var.environment
  enable_dns_support                  = var.enable_dns_support
  enable_dns_hostnames                = var.enable_dns_hostnames
  access_ip                           = var.access_ip
  name                                = var.name
  public_subnets                      = [for i in range(2, 25, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnets                     = [for i in range(1, 25, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets

  tags = {
    Environment = var.environment
    Project     = "SHALI Time Delta Project"
    Managed-By  = "Terraform"
    Pod         = "af-xtern-pod-a"
  }
}