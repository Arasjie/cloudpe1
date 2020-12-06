resource "aws_security_group" "loadbalancer" {
    name        = "loadbalancer-terraform"
    description = "loadbalancer"

  ingress {
    # TLS (change to whatever ports you need)
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "loadbalancer-terraform"
  }
}

resource "aws_lb" "loadbalancer" {
  name               = "loadbalancer-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.loadbalancer.id}"]
  subnets            = ["${aws_subnet.publicA.id}", "${aws_subnet.publicB.id}", "${aws_subnet.publicC.id}"]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}

resource "aws_lb_target_group" "front_end" {
    name     = "target-group-terraform"
    port     = 80
    protocol = "HTTP"
    vpc_id   = "vpc-12acc568"

}

resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.front_end.arn
  target_id        = aws_instance.weba1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb_target_group.front_end.arn
  target_id        = aws_instance.webb1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment3" {
  target_group_arn = aws_lb_target_group.front_end.arn
  target_id        = aws_instance.webc1.id
  port             = 80
}