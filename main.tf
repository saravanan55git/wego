# Create an ECS cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "demo-project"
}

# Define a task definition
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-family"
  container_definitions   = <<DEFINITION
  [
    {
      "name": "my-container",
      "image": "851725301149.dkr.ecr.us-east-1.amazonaws.com/fortune:latest",
      "cpu": 256,
      "memory": 512,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080,
          "protocol": "tcp"
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Create an IAM role for ECS instances
resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs-instance-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }]
  })
}

# Attach an IAM policy to the ECS instance role
resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role" # This is the managed policy for ECS instance role
}

# Create an EC2 instance for the ECS cluster
resource "aws_instance" "ecs_instance" {
  ami             = "ami-0440d3b780d96b29d"
  instance_type   = "t2.micro"  # or your preferred instance type
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.ecs_sg.id]  # assuming you have a security group defined for ECS
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name

  tags = {
    Name = "ecs-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.my_cluster.name} >> /etc/ecs/ecs.config
              EOF
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

# Define a security group for ECS instances
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Security group for ECS instances"
  vpc_id = aws_vpc.my_vpc.id
  # Define your security group rules as needed
  # For example, allow traffic on port 80 for HTTP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
