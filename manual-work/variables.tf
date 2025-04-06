variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "app_name" {
  description = "Application Name"
  default     = "m2m-docker-aws-hello-word"
}

variable "container_port" {
  description = "Application listening Port"
  default     = 3000
}

variable "cluster_name" {
  description = "Used for the ECS cluster"
  default     = "Hello-World"
}

variable "image_name" {
  description = "Docker image for the container"
  type        = string
  default     = "nmatsui/hello-world-api"
}

variable "application_replicas" {
  description = "Number of ECS task replicas"
  type        = number
  default     = 1
}