resource "aws_security_group" "alb_public_sg" {
  name        = "public-alb-sg"
  description = "Allow HTTP from internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
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

  tags = {
    Name = "public-alb-sg"
  }
}

resource "aws_security_group" "proxy_sg" {
  name        = "proxy-ec2-sg"
  description = "Allow traffic from public ALB and SSH"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_public_sg.id]
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
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
    Name = "proxy-ec2-sg"
  }
}

resource "aws_security_group" "alb_private_sg" {
  name        = "private-alb-sg"
  description = "Allow HTTP from proxy EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from Proxy"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.proxy_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-alb-sg"
  }
}

resource "aws_security_group" "apache_host_sg" {
  name        = "backend-ec2-sg"
  description = "Allow HTTP from private ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from private ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_private_sg.id]
  }

 ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
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
    Name = "apache-ec2-sg"
  }
}
