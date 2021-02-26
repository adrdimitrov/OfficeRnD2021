output "asg_name" {
  value       = aws_autoscaling_group.wordpress-asg.name
  description = "The name of the Auto Scaling Group"
}

output "asg_arn" {
  value       = aws_autoscaling_group.wordpress-asg.arn
  description = "The arn of the Auto Scaling Group"
}

output "asg_instance_security_group_id" {
  value       = aws_security_group.asg_instances.id
  description = "The ID of the EC2 Instance Security Group"
}
