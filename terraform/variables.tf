variable ec2_instance_type {
    type = string
    default = "t2.micro"
}

variable "aws_region" {
    type = string
    default = "ap-south-1"
}

variable "aws_profile" {
    type = string
    default = "default"
}