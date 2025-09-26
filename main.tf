provider "aws" {
  region = "us-east-2"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
locals {
  aws_key = "KEY_PAIR"   # SSH key pair name for EC2 instance access
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
  ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
  instance_type = var.instance_type            # Use the instance type from variables
  key_name      = "${local.aws_key}"          # Specify the SSH key pair name
  vpc_security_group_ids = [aws_security_group.wordpress.id]
  user_data = file("wp_install.sh")

  # Add tags to the EC2 instance for identification
  tags = {
    Name = "my ec2"
  } 
}

resource "aws_security_group" "wordpress" {
    name       = "wordpress"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "wordpress_public_ip" {
  value = aws_instance.my_server.public_ip
}

terraform {
  backend "s3"{

  }
}
