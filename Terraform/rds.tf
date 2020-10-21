resource "aws_security_group" "database" {
  name        = "DB-terraform"
  description = "DB"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web.id}"]
  }

  tags = {
    Name = "DB-terraform"
  }
}

data "aws_db_snapshot" "fase3dbsnapshot" {
    most_recent = true
    db_instance_identifier = "fase3db"
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${aws_subnet.privateA.id}", "${aws_subnet.privateB.id}", "${aws_subnet.privateC.id}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "service" {
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7.26"
  instance_class              = "db.t2.micro"
  name                        = "fase3db"
  username                    = "admin"
  password                    = "Pxl2019!"
  # password                    = aws_secretsmanager_secret_version.rdstf.secret_string
  identifier                  = "fase3db"
  skip_final_snapshot         = true
  snapshot_identifier         = data.aws_db_snapshot.fase3dbsnapshot.id
  db_subnet_group_name        = aws_db_subnet_group.default.name
  multi_az                    = true
  allow_major_version_upgrade = true
}