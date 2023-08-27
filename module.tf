# Variables
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
  default = "us-west-2"
}

# DATA
data "aws_ami" "aws_ubuntu" {
  most_recent = true
  owners      = ["amazon"]

 filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# RESOURCES
# Ami

resource "aws_instance" "aws_ubuntu" {
  instance_type          = "t4g.nano"
  ami                    = "ami-0c79a55dda52434da"
  user_data              = file("userdata.tpl")
}  

# Security group
resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "allow port 22, 80, 443"
  vpc_id      = "vpc-0c2a36846ba20e729"

   ingress {
        description       = "HTTPS"
        from_port         = 443
        to_port           = 443
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
    }
    
   ingress {
     from_port        = 22
     to_port          = 22
     protocol         = "tcp"
     cidr_blocks      = ["0.0.0.0/0"]
   }

   ingress {
     from_port        = 80
     to_port          = 80
     protocol         = "tcp"
     cidr_blocks      = ["0.0.0.0/0"]
   }

   egress {
     from_port        = 0
     to_port          = 0
     protocol         = "-1"
     cidr_blocks      = ["0.0.0.0/0"]
   }
}

# OUTPUT
output "aws_instance_public_dns" {
  value = aws_instance.aws_ubuntu.public_dns
}
