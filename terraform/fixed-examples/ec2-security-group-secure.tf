# This is a SECURE, fixed version of the EC2 security group

resource "aws_security_group" "secure_sg" {
  name        = "secure-sg"
  description = "Security group restricted to trusted access only"

  ingress {
    description = "Allow SSH only from trusted office IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.10/32"]
  }

  egress {
    description = "Allow outbound HTTPS only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.secure_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  monitoring  = true
  ebs_optimized = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }
}