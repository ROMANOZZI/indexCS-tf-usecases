## Generating Key Pair
## private key generation
# 1- create the private key
resource "tls_private_key" "index_private_key"{
  algorithm = "RSA"
  rsa_bits = 4096

}
# 2- save the private key into local file
resource "local_file" "index_key_file" {
  filename = "index_ec2_key.pem"
  content = tls_private_key.index_private_key.public_key_pem
  file_permission = "0400"
  
}

# 3- Import Public Key into aws
resource "aws_key_pair" "index_key_pair" {
  key_name = var.key_name
  public_key = tls_private_key.index_private_key.public_key_openssh
}


## creating the launch template for the frontend compute instances
resource "aws_launch_template" "frontend_launch_template" {
  name_prefix   = "frontend-launch-template"
  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.index_key_pair.key_name

  network_interfaces {
    security_groups = [var.frontend_app_sg]
    associate_public_ip_address = true
  }
  
}

## creating the launch template for the backend compute instances
resource "aws_launch_template" "backend_launch_template" {
  name_prefix   = "backend-launch-template"
  image_id      = var.image_id
  instance_type = var.backend_instance_type
  key_name      = aws_key_pair.index_key_pair.key_name

  network_interfaces {
    security_groups = [var.backend_app_sg]
    associate_public_ip_address = false
  }
  
}

resource "aws_lb_target_group" "frontend_lb_target_group" {
  name     = var.lb_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "backend_lb_target_group" {
  name     = var.backend_lb_tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_autoscaling_group" "frontend_asg" {
  max_size = var.maximum_instance_number
  min_size = var.minimum_instance_number
  desired_capacity = var.desired_instance_number
  vpc_zone_identifier = var.private_subnets
  launch_template {
    id=aws_launch_template.frontend_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "backend_asg" {
  max_size = var.maximum_instance_number
  min_size = var.minimum_instance_number
  desired_capacity = var.desired_instance_number
  vpc_zone_identifier = var.private_subnets
  launch_template {
    id=aws_launch_template.backend_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "frontend_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.frontend_asg.id
  lb_target_group_arn = aws_lb_target_group.frontend_lb_target_group.arn
  
}

resource "aws_autoscaling_attachment" "backend_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.backend_asg.id
  lb_target_group_arn = aws_lb_target_group.backend_lb_target_group.arn
  
}

