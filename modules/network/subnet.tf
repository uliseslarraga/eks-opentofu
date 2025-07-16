resource "aws_subnet" "public_subnet" {
  count                   = 3
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index + 3)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    {
      Name = "public-subnet-${count.index}",
      "kubernetes.io/role/elb" = "1",
      "kubernetes.io/cluster/eks-cluster-${var.environment}" = "shared"
    }, 
      var.tags
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge({Name = "public_route_table"}, var.tags)
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  tags = merge(
    {
      Name = "private-subnet-${count.index}",
      "kubernetes.io/role/internal-elb" = "1",
      "kubernetes.io/cluster/eks-cluster-${var.environment}" = "shared",
      "karpenter.sh/discovery" = "eks-cluster-development"
    }, 
    var.tags
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge({Name = "public_route_table"}, var.tags)
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_ngw.id
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_subnet" "private_subnet_data" {
  count      = 3
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index + 6)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  tags = merge({Name = "private-data-subnet-${count.index}"}, var.tags)
}

resource "aws_route_table_association" "private_data_route_table_association" {
  count          = length(aws_subnet.private_subnet_data)
  subnet_id      = aws_subnet.private_subnet_data[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}