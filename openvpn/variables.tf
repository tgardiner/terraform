variable "name" {
  type        = string
  description = "Applied to all resources"
}
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}
variable "ec2_subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to launch resources in"
}
variable "ami_id" {
  type        = string
  description = "The ID of the AMI"
}
variable "instance_type" {
  type        = string
  description = "The size of instance"
}
