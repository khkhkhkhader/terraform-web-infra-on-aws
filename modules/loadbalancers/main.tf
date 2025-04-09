# -----------------------
# Public Application Load Balancer
# -----------------------

resource "aws_lb" "public_alb" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_public_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "public-alb"
  }
}

resource "aws_lb_target_group" "public_tg" {
  name     = "public-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "public-alb-tg"
  }
}

resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "public_targets" {
  count            = length(var.proxy_instance_ids)
  target_group_arn = aws_lb_target_group.public_tg.arn
  target_id        = var.proxy_instance_ids[count.index]
  port             = 80
}

# -----------------------
# Private Application Load Balancer
# -----------------------

resource "aws_lb" "private_alb" {
  name               = "private-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_private_sg_id]
  subnets            = var.private_subnet_ids

  tags = {
    Name = "private-alb"
  }
}

resource "aws_lb_target_group" "private_tg" {
  name     = "private-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "private-alb-tg"
  }
}

resource "aws_lb_listener" "private_listener" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "private_targets" {
  count            = length(var.apache_instance_ids)
  target_group_arn = aws_lb_target_group.private_tg.arn
  target_id        = var.apache_instance_ids[count.index]
  port             = 80
}
