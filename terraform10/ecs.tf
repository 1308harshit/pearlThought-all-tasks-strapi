# resource "aws_ecs_cluster" "strapi" {
#   name = "strapi-cluster"
# }

# resource "aws_ecs_task_definition" "strapi_task" {
#   family                   = "strapi-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "2048"
#   memory                   = "4096"
#   execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"

#   container_definitions = jsonencode([{
#     name      = "strapi"
#     image     = "816069168735.dkr.ecr.us-east-1.amazonaws.com/strapi-app-image:latest"
#     essential = true
#     portMappings = [{
#       containerPort = 1337
#       hostPort      = 1337
#       protocol      = "tcp"
#     }]
#     environment = [
#       {
#         name  = "HOST"
#         value = "0.0.0.0"
#       },
#       {
#         name  = "APP_URL"
#         value = "http://${aws_lb.strapi_alb.dns_name}"
#       },
#       {
#         name  = "ALLOWED_HOSTS"
#         value = "${aws_lb.strapi_alb.dns_name}"
#       },
#       {
#         name  = "PORT"
#         value = "1337"
#       },
#       {
#         name  = "APP_KEYS"
#         value = "your_key1,your_key2"
#       }
#     ],
#     logConfiguration = {
#       logDriver = "awslogs",
#       options = {
#         awslogs-group         = "/ecs/strapi",
#         awslogs-region        = "us-east-1",
#         awslogs-stream-prefix = "strapi"
#       }
#     }
#   }])
# }


# resource "aws_ecs_cluster_capacity_providers" "cluster" {
#   cluster_name = aws_ecs_cluster.strapi.name
 
#   capacity_providers = ["FARGATE_SPOT", "FARGATE"]
 
#   default_capacity_provider_strategy {
#     capacity_provider = "FARGATE_SPOT"
#   }
# }

# resource "aws_ecs_service" "strapi_service" {
#   name            = "strapi-service"
#   cluster         = aws_ecs_cluster.strapi.id
#   desired_count   = 1

#   network_configuration {
#     subnets          = [aws_subnet.public_subnet_2.id]
#     assign_public_ip = true
#     security_groups  = [aws_security_group.strapi_sg.id]
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.blue.arn
#     container_name   = "strapi"
#     container_port   = 1337
#   }

#   task_definition = aws_ecs_task_definition.strapi_task.arn

#   capacity_provider_strategy {
#     capacity_provider = "FARGATE_SPOT"
#     weight            = 1

#   }

#   deployment_controller {
#   type = "CODE_DEPLOY"
#   }
# }

# -----------------------------------------------------------------------

resource "aws_ecs_cluster" "strapi_cluster" {
  name = "strapi-cluster"
}

resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"
  memory                   = "4096"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "strapi"
      image = var.image_uri
      portMappings = [{
        containerPort = 1337
        protocol      = "tcp"
      }]
      
    }
  ])
}

resource "aws_ecs_service" "strapi_service" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  desired_count   = 1
  # launch_type     = "FARGATE"
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets         = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg_blue.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.listener]
}