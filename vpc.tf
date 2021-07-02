resource "aws_vpc" "dev" {
  cidr_block =  var.cidr_vpc

  tags = {
    Name = var.aws_region
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.dev.id
  cidr_block        = var.cidr_subnet
  availability_zone = var.subnet_az
  tags = {
    Name = var.subnet_name
  }
  depends_on = [aws_internet_gateway.dev]
}

resource "aws_internet_gateway" "dev" {
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = var.ig_name
  }
}

resource "aws_network_acl" "dev" {
  vpc_id = aws_vpc.dev.id
  tags = {
    Name = var.acl_name
  }
}

resource "aws_network_acl_rule" "inbound" {
  count          = length(var.public_acl_inbound_tcp_ports)
  network_acl_id = aws_network_acl.dev.id
  rule_number    = count.index + 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = var.public_acl_inbound_tcp_ports[count.index]
  to_port        = var.public_acl_inbound_tcp_ports[count.index]
}

resource "aws_network_acl_rule" "outbound" {
  network_acl_id = aws_network_acl.dev.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev.id
}


resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

}