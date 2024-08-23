# OUTPUT FILES THAT WILL BE NEEDED BY OTHER RESOURCES
output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC cidr needed by other resources"
}

# Output the first Public Subnet IDs
output "public_subnet-1" {
  value       = aws_subnet.public[0].id
  description = "The first public subnet."
}

# Output the second  public Subnet IDs
output "public_subnet-2" {
  value       = aws_subnet.public[1].id
  description = "The second public subnet."
}

# Output the first Private Subnet IDs
output "private_subnet-1" {
  value       = aws_subnet.private[0].id
  description = "The first private subnet."
}

# Output the second Private Subnet IDs
output "private_subnet-2" {
  value       = aws_subnet.private[1].id
  description = "The second private subnet."
}

# # Output the third Private Subnet IDs
# output "private_subnet-3" {
#   value       = aws_subnet.private[2].id
#   description = "The third private subnet."

# }

# # Output the Private Subnet IDs
# output "private_subnet-4" {
#   value       = aws_subnet.private[3].id
#   description = "The 4th private subnet."
# }

# Output the Public Subnet IDs
output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

# Output the Private Subnet IDs
output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

# Output the Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.ig.id
}

#Output the Elastic IP for the NAT Gateway
output "nat_eip_id" {
  description = "The ID of the Elastic IP for the NAT Gateway"
  value       = aws_eip.nat_eip.id
}

# Output the NAT Gateway ID
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

# Output the Private Route Table ID
output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private-rtb.id
}

# Output the Public Route Table ID
output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public-rtb.id
}

# Output the Public Route Table Association IDs
output "public_route_table_association_ids" {
  description = "The IDs of the public route table associations"
  value       = aws_route_table_association.public-subnets-assoc[*].id
}

# Output the Private Route Table Association IDs
output "private_route_table_association_ids" {
  description = "The IDs of the private route table associations"
  value       = aws_route_table_association.private-subnets-assoc[*].id
}

# Output the Availability Zones
output "availability_zones" {
  description = "The availability zones used for the subnets"
  value       = data.aws_availability_zones.available.names
}

output "aws_security_group-id" {
  description = "Security group id to be used as default"
  value       = aws_security_group.default.id
}

