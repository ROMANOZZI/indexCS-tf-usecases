output "frontend_asg" {
    value=aws_autoscaling_group.frontend_asg
  
}
output "backend_asg" {
    value = aws_autoscaling_group.backend_asg
}