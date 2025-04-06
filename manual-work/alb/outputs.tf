output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "listener_arn" {
  value = aws_lb_listener.front_end.arn
}

output "lb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
