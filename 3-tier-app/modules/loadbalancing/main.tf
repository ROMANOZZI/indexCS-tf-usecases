resource "aws_lb" "frontend_lb" {
    name               = "frontend-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.lb_sg]
    subnets            = var.public_subnet_ids
}

resource "aws_lb_listener" "frontend_listener" {
    port              = var.listener_port
    protocol          = var.listener_protocol
    load_balancer_arn = aws_lb.frontend_lb.arn
    
    default_action {
      type             = "forward"
      target_group_arn = var.frontend_tg.arn
    }
}

resource "aws_lb" "backend_lb" {
    name               = "backend-lb"
    internal           = true
    load_balancer_type = "application"
    security_groups    = [var.backend_lb_sg]
    subnets            = var.private_subnet_ids
}

resource "aws_lb_listener" "backend_listener" {
    port              = var.listener_port
    protocol          = var.listener_protocol
    load_balancer_arn = aws_lb.backend_lb.arn
    
    default_action {
      type             = "forward"
      target_group_arn = var.backend_tg.arn
    }
}
