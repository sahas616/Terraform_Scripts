provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "instance2" {
  instance_type = "t2.micro"
  ami = "ami-0e001c9271cf7f3b9"
  user_data = file("scriptdemo.sh")
  tags = {
    Name = "My_Instance2"
  }
  vpc_security_group_ids = ["sg-0e85ca1b935f364ea"]
}