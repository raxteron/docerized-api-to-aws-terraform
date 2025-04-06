output "load_balancer_dns" {
  description = "Public DNS of the load balancer"
  value       = module.alb.lb_dns_name
}
