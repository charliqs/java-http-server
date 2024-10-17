terraform {
  backend "s3" {
    bucket         = "java-http-state"  # Ensure this matches the bucket name you created
    key            = "terraform.tfstate"               # Location of the state file in the bucket
    region         = "us-east-1"                       # S3 bucket region
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "java_http_server_sg" {
  name        = "java_http_server_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "java-http-server-sg"
  }
}

resource "aws_instance" "java_http_server" {
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.java_http_server_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              sudo apt-get install -y openjdk-17-jdk
              service docker start
              EOF

  key_name = aws_key_pair.my_key_pair.key_name

  tags = {
    Name = "java-http-server-instance"
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

output "instance_public_ip" {
  value = aws_instance.java_http_server.public_ip
}
