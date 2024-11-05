# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = merge({Name = "main_${var.environment}"}, var.tags)
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge({Name = "main_iw"}, var.tags)
}

resource "aws_eip" "nat_gw_eip" {
  tags = merge({Name = "nat-gw-eip"}, var.tags)
}

resource "aws_nat_gateway" "public_ngw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = merge({Name = "nat-gw"}, var.tags)
}