resource "aws_security_group" "allow_psql" {
  name        = "allow_plsq_sg_${var.environment}"
  description = "Allow RDS Aurora Postgres inbound traffic to EKS private subnets"
  vpc_id      = var.vpc_id
  tags = merge({Name = "allow_plsq_sg_${var.environment}"}, var.tags)
}

resource "aws_vpc_security_group_ingress_rule" "allow_plsql_traffic_ipv4" {
  security_group_id            = aws_security_group.allow_psql.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
  #TODO create SG for EKS Node group
  referenced_security_group_id = "default-eks-nodegroup"
}

resource "aws_vpc_security_group_ingress_rule" "allow_plsql_traffic_bh" {
  security_group_id            = aws_security_group.allow_psql.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
  referenced_security_group_id = var.bastionh_sg_id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_psql.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
