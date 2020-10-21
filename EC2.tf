data "aws_ami" "ec2-ami" {
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "tag:Name"
    values = ["packer-web"]
  }
  most_recent = true
  owners = ["624402370087"]
}

resource "aws_security_group" "web" {
  name        = "web-terraform"
  description = "web"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.loadbalancer.id}"]
  }

  egress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web-terraform"
  }
}

resource "aws_instance" "weba1" {
  ami                    = data.aws_ami.ec2-ami.id
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  key_name               = "firstbox"
  subnet_id              = aws_subnet.privateA.id

  tags = {
    Name = "terraform-web-A1"
  }
}

resource "aws_instance" "webb1" {
  ami                    = data.aws_ami.ec2-ami.id
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1b"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  key_name               = "firstbox"
  subnet_id              = aws_subnet.privateB.id

  tags = {
    Name = "terraform-web-B1"
  }
}

resource "aws_instance" "webc1" {
  ami                    = data.aws_ami.ec2-ami.id
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1c"
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  key_name               = "firstbox"
  subnet_id              = aws_subnet.privateC.id

  tags = {
    Name = "terraform-web-C1"
  }
}