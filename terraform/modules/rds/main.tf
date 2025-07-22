resource "aws_db_subnet_group" "rds" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "primary" {
  count                = var.create_replica ? 0 : 1
  identifier           = "${var.name}-db"
  instance_class       = "db.t3.micro"
  engine               = "mysql"
  engine_version       = "8.0"
  allocated_storage    = 20
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds.name
  multi_az             = true
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name = "${var.name}-rds"
  }
}

resource "aws_db_instance" "replica" {
  count                = var.create_replica ? 1 : 0
  identifier           = "${var.name}-replica"
  instance_class       = "db.t3.micro"
  engine               = "mysql"
  replicate_source_db  = var.source_db_arn
  db_subnet_group_name = aws_db_subnet_group.rds.name
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [var.sg_id]

  tags = {
    Name = "${var.name}-rds-replica"
  }
}
