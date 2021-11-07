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
  default     = "10.0.0.0"
  description = "The network address of the VPC"
}
variable "vpc_netmask" {
  type        = number
  default     = 16
  description = "The netmask of the VPC"
}
variable "subnet_netmask" {
  type        = number
  default     = 24
  description = "The netmask of each subnet inside the VPC"
}
