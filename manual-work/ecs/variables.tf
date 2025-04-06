variable "app_name" {}
variable "cluster_name" {}
variable "container_port" {}
variable "subnets" {
  type = list(string)
}
variable "sg_id" {}
variable "target_group_arn" {}
variable "lb_listener_arn" {}
variable "vpc_id" {}
variable "image_name" {}
variable "application_replicas" {}