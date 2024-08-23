output "vpc_id" {
  value = module.vpc.vpc_id # Reference to the submodule output
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids # Reference to the submodule output
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids # Reference to the submodule output
}

## output files for use.

