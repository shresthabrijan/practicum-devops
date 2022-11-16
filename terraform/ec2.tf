data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "cf-ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.cf-ec2-sg.id]
  
  depends_on = [ 
    aws_security_group.cf-ec2-sg
  ]

  user_data = file("${path.module}/userdata.sh")
}

resource "aws_security_group" "cf-ec2-sg" {
  name        = "cf-ec2-sg"
  description = "Demo security group for careerfoundry deployment"

  // To Allow Port 80 Transport
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.cf-ec2.id
  vpc      = true
}

output "Public-IP" {
  value = aws_eip.eip.public_ip
}

