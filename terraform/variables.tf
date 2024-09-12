variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "cidr_block" {
  type        = string
  description = "CIDR Block"
}
variable "project_name" {
  type        = string
  description = "Project Name"
}