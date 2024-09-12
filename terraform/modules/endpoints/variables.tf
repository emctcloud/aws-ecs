variable "aws_region" {
  type        = string
  description = "AWS Region"
}
variable "vpc_id" {
  type        = string
  description = "VPC Nat"
}
variable "vpc_name" {
  description = "VPC Associated"
  type        = string
  default     = "Terraform-AWS-ECS"
}
variable "cidr_block" {
  type        = string
  description = "CIDR block"
}
variable "private_rtb_ids" {
  description = "IDs"
  type        = list(string)
}
variable "private_sub_ids" {
  description = "IDs"
  type        = list(string)
}