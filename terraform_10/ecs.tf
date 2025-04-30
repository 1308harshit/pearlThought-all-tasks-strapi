resource "aws_ecs_cluster" "strapi_cluster" {
        name = "strapi-cluster"
      }
      resource "aws_ecs_service" "strapi_service" {
        name = "strapi-service"
        cluster = aws_ecs_cluster.strapi_cluster.id
        task_definition = aws_ecs_task_definition.strapi.arn
        deployment_controller {
          type = "CODE_DEPLOY"
        }
        load_balancer {
          target_group_arn = aws_lb_target_group.blue.arn
          container_name = "strapi-container"
          container_port = 1337
        }
        desired_count = 1
        launch_type = "FARGATE"
        network_configuration {
          subnets         = var.private_subnets
          security_groups = [aws_security_group.ecs.id]
        }
      }
      resource "aws_ecs_task_definition" "strapi" {
        family                   = "strapi-task-def"
        requires_compatibilities = ["FARGATE"]
        network_mode             = "awsvpc"
        cpu                      = "512"
        memory                   = "1024"
        execution_role_arn      = var.execution_role_arn
        container_definitions   = file("../taskdef.json")
      }