resource "aws_lb" "strapi_alb" {
  name               = "strapi-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "strapi_blue_tg" {
  name         = "strapi-blue-tg"
  port         = 1337
  protocol     = "HTTP"
  vpc_id       = aws_vpc.main.id
  target_type  = "ip"
}

resource "aws_lb_target_group" "strapi_green_tg" {
  name         = "strapi-green-tg"
  port         = 1337
  protocol     = "HTTP"
  vpc_id       = aws_vpc.main.id
  target_type  = "ip"
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_blue_tg.arn
  }
}

# resource "aws_lb_listener" "listener_https" {
#   load_balancer_arn = aws_lb.strapi_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"

#   ssl_policy = "ELBSecurityPolicy-2016-08"
#   certificate_arn = 

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.strapi_blue_tg.arn
#   }
# }
