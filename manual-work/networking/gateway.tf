resource "aws_internet_gateway" "gw" {
  tags = {
    Name = "${var.app_name}-igw"
  }

  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  tags = {
    Name = "${var.app_name}-rt"
  }

  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}