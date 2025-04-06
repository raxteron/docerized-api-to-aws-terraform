variable "app_name" {
  description = "App Name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "container_port" {
  description = "Port exposed by container/service"
  type        = number
}
