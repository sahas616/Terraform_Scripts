variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "kubernetes_version" {
  type = string
  default = "1.30"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}