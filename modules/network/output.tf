output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "pub_subnet_cidrs" {
  value = aws_subnet.public_subnet[*].cidr_block
}

output "pub_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "priv_subnet_cidrs" {
  value = aws_subnet.private_subnet[*].cidr_block
}

output "priv_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "priv_data_subnet_cidrs" {
  value = aws_subnet.private_subnet_data[*].cidr_block
}

output "priv_data_subnet_ids" {
  value = aws_subnet.private_subnet_data[*].id
}