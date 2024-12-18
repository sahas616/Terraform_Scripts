provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "az_names" {

}

resource "random_string" "randomstring" {
  length = 6
  special = false
}

locals {
  cluster_name = "eks-cluster-${random_string.randomstring.result}"
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    name = "eks-vpc"
    cidr = var.vpc_cidr
    azs = data.aws_availability_zones.az_names.names
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets = ["10.0.4.0/24", "10.0.5.0/24"]
    enable_nat_gateway = true
    enable_vpn_gateway = true
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    }

    public_subnet_tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/elb" = "1"
  }

    private_subnet_tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/internal-elb" = "1"
  }
}

/* output "availabilityzones" {
  value = [data.aws_availability_zones.az_names.names, data.aws_availability_zones.az_names.id]
} */