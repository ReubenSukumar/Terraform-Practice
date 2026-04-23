####################################################             Application Load  Balancer              #####################################################################




resource "aws_lb" "T_public_ALB" {
  name               = var.Public_ALB_Name                                # Desired name for Public ALB
  internal           = false                                              # Public facing ALB (false)
  load_balancer_type = "application"
  security_groups    = [var.public_alb_id]                                # Public ALB ID variable
  subnets            = var.public_subnets                                 # Subnets variable to be included for Public ALB                      

  enable_deletion_protection = false                                      # *NOTE*: Setting this to `true` will prevent Terraform from destroying the resource
}


resource "aws_lb" "T_private_ALB" {
  name               = var.Private_ALB_Name                               # Desired name for Private ALB
  internal           = true                                               # Internal facing ALB (true)
  load_balancer_type = "application"
  security_groups    = [var.private_alb_id]                               # Private ALB ID variable
  subnets            = var.private_subnets                                # Subnets variable to be included for Private ALB             

  enable_deletion_protection = false                                      # *NOTE*: Setting this to `true` will prevent Terraform from destroying the resource
}




####################################################               Target Group                 ###########################################################################




resource "aws_lb_target_group" "T_public_ALB_TG" {                                 # Public ALB TG
  name      = "${var.Public_ALB_Name}-TG"
  port      = 80
  protocol  = "HTTP"
  vpc_id    = var.vpc_id                                                           # VPC ID variable
  health_check {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"  # Use the same port as the target
    protocol            = "HTTP"
    healthy_threshold   = 5               # Consecutive successes to mark healthy
    unhealthy_threshold = 2               # Consecutive failures to mark unhealthy
    timeout             = 5               # Seconds to wait for a response
    interval            = 30              # Seconds between checks
    matcher             = "200"           # Expected HTTP status code
  }
}

resource "aws_lb_listener" "pub_alb_listener" {
  load_balancer_arn = aws_lb.T_public_ALB.arn                                      # Define HTTPS Listener Rule for Public ALB
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   =  var.acm_certify_validation

  default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.T_public_ALB_TG.arn
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.T_public_ALB.arn                                      # Define HTTP redirect to HTTPS Listener Rule for Public ALB
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group_attachment" "T_public_ALB_TG_EC2_sub1_attachment" {  # Attach the Instance to Target Group (Public ALB)
  target_group_arn = aws_lb_target_group.T_public_ALB_TG.arn
  target_id        = var.public_1_instance_id                                      # Public Instance-1 ID variable          
  port             = 80
}

resource "aws_lb_target_group_attachment" "T_public_ALB_TG_EC2_sub2_attachment" {  # Attach the Instance to Target Group (Public ALB)
  target_group_arn = aws_lb_target_group.T_public_ALB_TG.arn
  target_id        = var.public_2_instance_id                                      # Public Instance-2 ID variable
  port             = 80
}



resource "aws_lb_target_group" "T_private_ALB_TG" {                                # Private ALB TG
  name      = "${var.Private_ALB_Name}-TG"
  port      = 8080
  protocol  = "HTTP"
  vpc_id    = var.vpc_id                                                           # VPC ID variable
  health_check {
    enabled             = true
    path                = "/health"
    port                = "traffic-port"  # Use the same port as the target
    protocol            = "HTTP"
    healthy_threshold   = 5               # Consecutive successes to mark healthy
    unhealthy_threshold = 2               # Consecutive failures to mark unhealthy
    timeout             = 5               # Seconds to wait for a response
    interval            = 30              # Seconds between checks
    matcher             = "200"           # Expected HTTP status code
  }
}

resource "aws_lb_listener" "pri_alb_listener" {                                    # Define Listener Rule for Private ALB
  load_balancer_arn = aws_lb.T_private_ALB.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.T_private_ALB_TG.arn
  }
}

resource "aws_lb_target_group_attachment" "T_private_ALB_TG_EC2_sub1_attachment" {
  target_group_arn = aws_lb_target_group.T_private_ALB_TG.arn                      # Attach the Instance to Target Group (Private ALB)
  target_id        = var.private_1_instance_id                                     # Private Instance-1 ID variable
  port             = 8080
}

resource "aws_lb_target_group_attachment" "T_private_ALB_TG_EC2_sub2_attachment" {
  target_group_arn = aws_lb_target_group.T_private_ALB_TG.arn                      # Attach the Instance to Target Group (Private ALB)
  target_id        = var.private_2_instance_id                                     # Private Instance-2 ID variable
  port             = 8080
}