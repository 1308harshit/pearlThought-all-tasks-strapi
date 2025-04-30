resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster"
}

# task definition for strapi
resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = var.ecr_image
      essential = true
      portMappings = [{
        containerPort = 1337
        hostPort      = 1337
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.strapi_log_group.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs/strapi"
        }
      }
    }
  ])

  depends_on = [aws_cloudwatch_log_group.strapi_log_group]
}

# ECS Service
resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  desired_count   = 1

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  # Add this load balancer configuration
  load_balancer {
    target_group_arn = aws_lb_target_group.blue_tg.arn # Initial target group
    container_name   = "strapi"
    container_port   = 1337
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [
      task_definition, # CodeDeploy will manage this
      load_balancer    # CodeDeploy will handle traffic shifting
    ]
  }
}