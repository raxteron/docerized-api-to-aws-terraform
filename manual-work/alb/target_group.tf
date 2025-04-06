resource "aws_lb_target_group" "app_tg" {
  tags = {
    Name = "${var.app_name}-tg"
  }

  name        = "${var.app_name}-app-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

}