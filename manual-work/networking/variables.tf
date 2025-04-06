variable "app_name" {
  type = string
}

variable "container_port" {
  description = "Port exposed by container/service"
  type        = number
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_prefix" {
  description = "Subnet size"
  type        = number
  default     = 24
}

variable "allowed_ingress_cidr" {
  description = "IP's allowed to access ALB Security group"
  type        = string
  default     = "0.0.0.0/0"
}
