variable "name" {
  type        = string
  description = "Applied to all resources"
}
variable "region" {
  type        = string
  description = "Resources will be provisioned in this region"
}
variable "vpc_network" {
  type        = string
  description = "The network address of the VPC"
}
variable "vpc_netmask" {
  type        = number
  description = "The netmask of the VPC"
}
variable "vpc_subnet_netmask" {
  type        = number
  description = "The netmask of each subnet inside the VPC"
}
