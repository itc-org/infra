resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

################################
# ECS Cluster
################################

resource "aws_ecs_cluster" "this" {
  name = var.ecs_name
}

# ################################
# # IAM Role for Task Execution
# ################################

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "ecsTaskExecutionRole-${random_string.suffix.result}"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ecs-tasks.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# ################################
# # Security Group
# ################################

# resource "aws_security_group" "ecs" {
#   name   = "terraform-ecs-sg-${random_string.suffix.result}"
#   vpc_id = var.vpc_id

#   ingress {
#     from_port   = var.container_port
#     to_port     = var.container_port
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# ################################
# # CloudWatch Logs
# ################################

# resource "aws_cloudwatch_log_group" "ecs" {
#   name = "/ecs/terraform-${random_string.suffix.result}"
# }

# ################################
# # Task Definition
# ################################

# resource "aws_ecs_task_definition" "this" {
#   family                   = "terraform-task-${random_string.suffix.result}"
#   requires_compatibilities = ["FARGATE"]
#   network_mode             = "awsvpc"
#   cpu                      = "256"
#   memory                   = "512"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

#   container_definitions = jsonencode([
#     {
#       name  = "app"
#       image = var.container_image
#       portMappings = [
#         {
#           containerPort = var.container_port
#           protocol      = "tcp"
#         }
#       ]
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = aws_cloudwatch_log_group.ecs.name
#           awslogs-region        = data.aws_region.current.region
#           awslogs-stream-prefix = "ecs"
#         }
#       }
#     }
#   ])
# }

# data "aws_region" "current" {}

# ################################
# # ECS Service
# ################################

# resource "aws_ecs_service" "this" {
#   name            = "terraform-service-${random_string.suffix.result}"
#   cluster         = aws_ecs_cluster.this.id
#   task_definition = aws_ecs_task_definition.this.arn
#   launch_type     = "FARGATE"
#   desired_count   = 1

#   network_configuration {
#     subnets          = var.subnet_ids
#     security_groups  = [aws_security_group.ecs.id]
#     assign_public_ip = true
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.ecs_task_execution_policy
#   ]
# }
