resource "aws_launch_configuration" "wordpress-asg" {
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.asg_instances.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "wordpress-asg" {
  name = "${var.cluster_name}-${aws_launch_configuration.wordpress-asg.name}"

  launch_configuration = aws_launch_configuration.wordpress-asg.name

  vpc_zone_identifier  = var.subnet_ids

  target_group_arns    = var.target_group_arns
  health_check_type    = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  min_elb_capacity = var.min_size

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.wordpress-asg.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.wordpress-asg.name
}

resource "aws_security_group" "asg_instances" {
  name   = "${var.cluster_name}-instance"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.asg_instances.id

  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = var.tcp_protocol
  source_security_group_id = var.inbound_ips
}
