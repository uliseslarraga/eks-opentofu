resource "aws_rds_cluster" "default" {
  cluster_identifier     = "psql-cluster-${var.environment}"
  engine                 = "aurora-postgresql"
  engine_version         = "14.6"
  database_name          = "products"
  master_username        = "java_app"
  master_password        = "password"
  skip_final_snapshot    = true #enabled for testing purposes
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_psql.id]
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count                   = 2
  identifier              = "psql-instance-${var.environment}-${count.index}"
  cluster_identifier      = aws_rds_cluster.default.id
  instance_class          = "db.t3.medium"
  engine                  = aws_rds_cluster.default.engine
  engine_version          = aws_rds_cluster.default.engine_version
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  tags                    = merge({Name = "rds-cluster-${var.environment}"}, var.tags)
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db-subnet-group-${var.environment}"
  subnet_ids = var.private_data_subnets

  tags = merge({Name = "db-subnet-group-${var.environment}"}, var.tags)
}
