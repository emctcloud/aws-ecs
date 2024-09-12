terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
  }
  backend "s3" {
    bucket = "emctx-terraform-ecs"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region = "us-east-1"
}