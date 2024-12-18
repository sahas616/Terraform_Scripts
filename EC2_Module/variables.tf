variable "ami" {
  description = "value"
}

variable "instance_type" {
  description = "value"
  type = map(string)

  default = {
    "dev" = "t2.nano"
    "stage" = "t2.micro"
    "prod" = "t2.medium"
  }
}

variable "instancename" {
  description = "instance_name"
}


