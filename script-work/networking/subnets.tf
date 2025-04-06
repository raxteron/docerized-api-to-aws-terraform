data "aws_availability_zones" "available" {}

locals {
  vpc_cidr_prefix = tonumber(split("/", var.vpc_cidr)[1])
  subnet_bits     = var.public_subnet_prefix - local.vpc_cidr_prefix
}

resource "aws_subnet" "public" {
  tags = {
    Name = "${var.app_name}-subnet-${count.index + 1}"
  }

  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, local.subnet_bits, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}