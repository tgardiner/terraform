locals {
  subnet_newbits = var.subnet_netmask - var.vpc_netmask
  tags = {
    ManagedBy = "Terraform"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block           = "${var.vpc_network}/${var.vpc_netmask}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      "Name" = "${var.name}-vpc"
    },
    local.tags
  )
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name" = "${var.name}-vpc-default"
    },
    local.tags
  )
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = merge(
    {
      "Name" = "${var.name}-vpc-private"
    },
    local.tags
  )
}

resource "aws_internet_gateway" "this" {
  count = length(data.aws_availability_zones.available.names) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = "${var.name}-vpc-gateway"
    },
    local.tags
  )
}

resource "aws_route_table" "public" {
  count = length(data.aws_availability_zones.available.names) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = "${var.name}-vpc-public"
    },
    local.tags
  )
}

resource "aws_route" "public_internet_gateway" {
  count = length(data.aws_availability_zones.available.names) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet("${var.vpc_network}/${var.vpc_netmask}", local.subnet_newbits, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format("%s-vpc-public-%s",
        var.name,
        split("-", data.aws_availability_zones.available.names[count.index])[2]
      )
      "Type" = "public"
    },
    local.tags
  )
}

resource "aws_route_table_association" "public" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet("${var.vpc_network}/${var.vpc_netmask}", local.subnet_newbits, length(data.aws_availability_zones.available.names) + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      "Name" = format("%s-vpc-private-%s",
        var.name,
        split("-", data.aws_availability_zones.available.names[count.index])[2]
      )
      "Type" = "private"
    },
    local.tags
  )
}

resource "aws_route_table_association" "private" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_default_route_table.this.id
}
