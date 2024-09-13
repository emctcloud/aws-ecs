resource "aws_security_group" "this" {
  name = "aws_sg_01"
  description = ""
  vpc_id = aws_vpc.ecs-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ var.allowed_ip ]
  }
  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}