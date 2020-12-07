resource "aws_security_group" "database-terraform" {
  name        = "DB-terraform"
  description = "DB"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["aws_security_group.web.id"]
  }

  tags = {
    Name = "DB-terraform"
  }
}

resource "aws_db_instance" "prod" {
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7.26"
  instance_class              = "db.t2.micro"
  name                        = "fase1db"
  username                    = "admin"
  password                    = "Pxl2020!"
  # password                    = aws_secretsmanager_secret_version.rdstf.secret_string
  identifier                  = "fase1db"
  db_subnet_group_name        = aws_db_subnet_group.default.name
  multi_az                    = true
  allow_major_version_upgrade = true
}

data "aws_db_snapshot" "latest_prod_snapshot" {
  most_recent = true
  db_instance_identifier = aws_db_instance.prod.id
}

resource "aws_db_instance" "dev" {
  instance_class = "db.t2.micro"
  name           = "fase1dbdev"
  snapshot_identifier = data.aws_db_snapshot.latest_prod_snapshot.id

  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.privateA.id, aws_subnet.privateB.id, aws_subnet.privateC.id]

  tags = {
    Name = "My DB subnet group"
  }
}
