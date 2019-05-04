variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default = "us-west-1"
}

variable "amis" {
  description = "AMIs by region"
  default = {
    us-west-1 = "ami-0a219c4755cf23cc3" # ubuntu 14.04 LTS
  }
}

variable "vpc_cider" {
  description = "CIDR for the whole VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cider" {
  description = "CIDR for the Public Subnet"
  default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default = "10.0.1.0/24"
}

