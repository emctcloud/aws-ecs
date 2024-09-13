resource "aws_security_group" "this" {
  name        = "aws_sg_01"
  description = "Allows SSH Conection"
  vpc_id      = aws_vpc.ecs-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "this" {
  name = "my-instance-profile"
  role = "AmazonEC2RoleForSSM"
}

resource "aws_instance" "this" {
  ami                    = "ami-0182f373e66f89c85"
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.ecs_sub_pub_1a.id
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name
}