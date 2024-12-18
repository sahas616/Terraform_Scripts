provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "My_VPC"
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "My_Subnet1"
  }
}
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "My_Subnet2"
  }
}
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "My_Gateway"
  }
}
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
  tags = {
    Name = "My_RT"
  }
}
resource "aws_route_table_association" "RTA1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.RT.id
}
resource "aws_route_table_association" "RTA2" {
  subnet_id = aws_subnet.subnet2.id
  route_table_id = aws_route_table.RT.id
}
resource "aws_security_group" "SG" {
  vpc_id = aws_vpc.vpc1.id
  name = "My_SG"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "instance1" {
  instance_type = "t2.micro"
  ami = "ami-0e001c9271cf7f3b9"
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.SG.id]
  user_data = base64encode(file("scriptdemo1.sh"))
  tags = {
    Name = "My_Instance1"
  }
}
resource "aws_instance" "instance2" {
  instance_type = "t2.micro"
  ami = "ami-0e001c9271cf7f3b9"
  subnet_id = aws_subnet.subnet2.id
  vpc_security_group_ids = [aws_security_group.SG.id]
  user_data = base64encode(file("scriptdemo2.sh"))
  tags = {
    Name = "My_Instance2"
  }
}
resource "aws_s3_bucket" "s3bucket" {
  bucket = "my-aws-s3-bucket-terraform-project-123"
}
resource "aws_s3_bucket_public_access_block" "s3bucketpublic" {
  bucket = aws_s3_bucket.s3bucket.id
  block_public_acls = false
  block_public_policy = false
}
resource "aws_lb" "alb" {
  name = "my-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.SG.id]
  subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}
resource "aws_lb_target_group" "tg" {
  name = "mytargetgroup"
  vpc_id = aws_vpc.vpc1.id
  port = 80
  protocol = "HTTP"
  health_check {
    path = "/"
    port = "traffic-port"
  }
}
resource "aws_lb_target_group_attachment" "tga1" {
  target_id = aws_instance.instance1.id
  target_group_arn = aws_lb_target_group.tg.arn
  port = 80
}
resource "aws_lb_target_group_attachment" "tga2" {
  target_id = aws_instance.instance2.id
  target_group_arn = aws_lb_target_group.tg.arn
  port = 80
}
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
output "data_output" {
  value = aws_lb.alb.dns_name
}