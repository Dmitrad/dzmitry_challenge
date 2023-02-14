resource "aws_launch_configuration" "test" {
  name                        = "test"
  image_id                    = data.aws_ami.example.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_tls.id]
  user_data                   = file(var.user_data_file)
  key_name                    = var.ssh_key_name
  
}


resource "aws_autoscaling_group" "test" {
  name                 = "test"
  max_size             = 2
  min_size             = 1
  desired_capacity     = 1
  force_delete         = false
  launch_configuration = aws_launch_configuration.test.name
  vpc_zone_identifier  = [aws_subnet.public_1.id]

  tag {
    key                 = "test"
    value               = "yes"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "test" {
  name                   = "cpu-policy-test"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.test.name
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "test" {
  alarm_name                = "test-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

 dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.test.name
  }
    alarm_actions     = [aws_autoscaling_policy.test.arn]
}

resource "aws_autoscaling_policy" "test_down" {
  name                   = "cpu-policy-test"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.test.name
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "test_down" {
  alarm_name                = "test-cpu-alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "50"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

 dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.test.name
  }
    alarm_actions     = [aws_autoscaling_policy.test_down.arn]
}

resource "aws_lb" "test" {
  name               = "test"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  enable_deletion_protection = false


  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "http" {
  name     = "http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    port                = "traffic-port"
    path                = "/"
    matcher             = "200-320"

  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_http" {
  autoscaling_group_name = aws_autoscaling_group.test.id
  lb_target_group_arn    = aws_lb_target_group.http.arn
}


resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:463496056235:certificate/d9ad112a-1b17-4516-8243-00e478469337"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}





