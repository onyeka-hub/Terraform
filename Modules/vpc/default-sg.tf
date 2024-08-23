resource "aws_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.access_ip]
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s-default-sg-%s", var.name, var.environment)
    }
  )
} 