provider "aws" {
  region = "us-east-1"
}

module "module" {
  source = "./module"
  ami = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
  instancename = "${var.instancename}-${terraform.workspace}"

}