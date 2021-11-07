output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}
output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.this.arn
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}
output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.this.default_security_group_id
}
output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = aws_vpc.this.default_network_acl_id
}
output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = aws_vpc.this.default_route_table_id
}
output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = aws_vpc.this.main_route_table_id
}
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}
output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private.*.arn
}
output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private.*.cidr_block
}
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}
output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public.*.arn
}
output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.public.*.cidr_block
}
output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = aws_route_table.public[0].id
}
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this[0].id
}
