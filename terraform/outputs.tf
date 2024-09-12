output "vpc" {
  value = {
    id         = aws_vpc.ecs-vpc.id
    arn        = aws_vpc.ecs-vpc.arn
    cidr_block = aws_vpc.ecs-vpc.cidr_block
  }
}

output "aws_subnet" {
  value = {
    private = {
      id         = [aws_subnet.ecs_sub_priv_1a.id, aws_subnet.ecs_sub_priv_1b.id]
      cidr_block = [aws_subnet.ecs_sub_priv_1a.cidr_block, aws_subnet.ecs_sub_priv_1b.cidr_block]
    }
    public = {
      id         = [aws_subnet.ecs_sub_pub_1a.id, aws_subnet.ecs_sub_pub_1b.id]
      cidr_block = [aws_subnet.ecs_sub_pub_1a.cidr_block, aws_subnet.ecs_sub_pub_1b.cidr_block]
    }
  }
}

output "route_tables" {
  value = {
    private = {
      id = [aws_route_table.ecs_priv_route_table.id]
    }
    public = {
      id = [aws_route_table.ecs_pub_route_table.id]
    }
  }
}