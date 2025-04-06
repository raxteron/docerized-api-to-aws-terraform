module "networking" {
  source = "networking"

  app_name             = var.app_name
  container_port       = var.container_port
  vpc_cidr             = "10.1.0.0/22"
  public_subnet_prefix = 26
  allowed_ingress_cidr = "0.0.0.0/0"
}

module "alb" {
  source         = "alb"
  app_name       = var.app_name
  container_port = var.container_port
  vpc_id         = module.networking.vpc_id
  subnets        = module.networking.public_subnet_ids
  sg_id          = module.networking.alb_sg_id
}

module "ecs" {
  source     = "ecs"
  depends_on = [module.alb]

  app_name             = var.app_name
  container_port       = var.container_port
  image_name           = var.image_name
  application_replicas = var.application_replicas
  cluster_name         = "Hello-World"
  subnets              = module.networking.public_subnet_ids
  sg_id                = module.networking.ecs_sg_id
  target_group_arn     = module.alb.target_group_arn
  lb_listener_arn      = module.alb.listener_arn
  vpc_id               = module.networking.vpc_id
}