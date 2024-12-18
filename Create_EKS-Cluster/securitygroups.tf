resource "aws_security_group" "sgroup" {
  name_prefix = "eks-worker-group"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "ingress_rules" {
  description = "allow inbound traffic"
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.sgroup.id
  cidr_blocks = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]
}

resource "aws_security_group_rule" "egress_rules" {
  description = "allow outbound traffic"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.sgroup.id
  cidr_blocks = ["0.0.0.0/0"]
}