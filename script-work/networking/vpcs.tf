resource "aws_vpc" "main" {
  tags = {
    Name = "${var.app_name}-vpc"
  }

  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}