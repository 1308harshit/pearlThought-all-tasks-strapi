   resource "aws_codedeploy_app" "strapi_app" {
        name = "strapi-codedeploy-app"
        compute_platform = "ECS"
      }
      resource "aws_codedeploy_deployment_group" "strapi_dg" {
        app_name              = aws_codedeploy_app.strapi_app.name
        deployment_group_name = "strapi-deploy-group"
        service_role_arn      = var.codedeploy_role_arn
        deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"
        ecs_service {
          cluster_name = aws_ecs_cluster.strapi_cluster.name
          service_name = aws_ecs_service.strapi_service.name
        }
        load_balancer_info {
          target_group_pair_info {
            prod_traffic_route {
              listener_arns = [aws_lb_listener.http.arn]
            }
            target_group {
              name = aws_lb_target_group.blue.name
            }
            target_group {
              name = aws_lb_target_group.green.name
            }
          }
        }
        auto_rollback_configuration {
          enabled = true
          events  = ["DEPLOYMENT_FAILURE"]
        }
        blue_green_deployment_config {
          terminate_blue_instances_on_deployment_success {
            action = "TERMINATE"
            termination_wait_time_in_minutes = 5
          }
        }
      }