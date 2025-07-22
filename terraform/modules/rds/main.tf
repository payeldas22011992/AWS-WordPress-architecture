resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  count                = var.create_replica ? 0 : 1
  identifier           = "${var.name}-primary"
  instance_class       = var.instance_type
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  username             = var.db_username
  password             = var.db_password
  multi_az             = true
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.sg_id]
  skip_final_snapshot  = true

  tags = {
    Name = "${var.name}-primary"
  }
}

resource "aws_db_instance" "replica" {
  count                = var.create_replica ? 1 : 0
  identifier           = "${var.name}-replica"
  instance_class       = var.instance_type
  engine               = "mysql"
  replicate_source_db  = var.source_db_arn
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.sg_id]
  skip_final_snapshot  = true

  tags = {
    Name = "${var.name}-replica"
  }
}
