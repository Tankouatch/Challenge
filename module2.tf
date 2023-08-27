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
  description = "allow ssh on 22 & http on port 80"
  vpc_id      = "vpc-0c2a36846ba20e729"

#   ingress {
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }
}

resource "aws_lb" "example_lb" {
  name               = "example-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.demo_sg.id]
  subnets            = ["subnet-0068679226e81966f",
                        "subnet-0db7119e20b440c97",
                        "subnet-056f4097e702e48ac",
                        "subnet-07c4289662cca87e6",
                      ]  

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "example_tg" {
  name     = "example-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-0c2a36846ba20e729"
}

resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.example_lb.arn
  port              = 80

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Welcome to Nginx"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group_attachment" "example_tg_attachment" {
  target_group_arn = aws_lb_target_group.example_tg.arn
  target_id        = aws_instance.aws_ubuntu.id
  port             = 80
}

resource "aws_acm_certificate" "example_cert" {
  domain_name       = "tchouetckeatankoua.interview.exosite.biz"
  validation_method = "DNS"
}

resource "aws_lb_listener_certificate" "example_https_cert" {
  listener_arn    = aws_lb_listener.example_listener.arn
  certificate_arn = aws_acm_certificate.example_cert.arn
}


# OUTPUT
output "aws_instance_public_dns" {
  value = aws_instance.aws_ubuntu.public_dns
}
