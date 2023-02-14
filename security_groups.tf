resource "aws_security_group" "allow_tls" {
  name        = "allow_test"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLC from VPC" 
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_cidrs #["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_cidrs #["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}





