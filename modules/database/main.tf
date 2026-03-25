# -------------------------
# DB SUBNET GROUP
# -------------------------
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.name_prefix}-db-subnet-group"
  }
}

# -------------------------
# SECURITY GROUP FOR RDS
# -------------------------
resource "aws_security_group" "db_sg" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Allow traffic from compute instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.compute_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }
}

# -------------------------
# RDS MYSQL INSTANCE
# -------------------------
resource "aws_db_instance" "mysql" {
  identifier     = "${var.name_prefix}-mysql-db"
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage    = var.allocated_storage
  storage_type         = "gp2"
  storage_encrypted    = true
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true
  backup_retention_period = 7

  tags = {
    Name = "${var.name_prefix}-mysql-db"
  }
}
