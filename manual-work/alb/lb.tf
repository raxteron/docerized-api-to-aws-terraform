resource "aws_lb" "app_lb" {
  tags = {
    Name = "${var.app_name}-alb"
  }

  name               = "${var.app_name}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.subnets
}
