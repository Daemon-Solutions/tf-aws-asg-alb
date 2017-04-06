resource "aws_route53_record" "alb" {
  count   = "${var.alb_dns}"
  zone_id = "${var.route53_zone_id}"
  name    = "${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb.dns_name}"
    zone_id                = "${aws_alb.alb.zone_id}"
    evaluate_target_health = true
  }
}

// S3 Bucket For Logs
resource "aws_s3_bucket" "alb_log_bucket" {
  bucket        = "${var.name}-${var.log_s3bucket}"
  force_destroy = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSALBS3Logging",
      "Effect": "Allow",
      "Action": "s3:PutObject",
      "Principal": { "AWS": "arn:aws:iam::${lookup(var.alb_aws_account, var.region)}:root" },
      "Resource": "arn:aws:s3:::${var.name}-${var.log_s3bucket}/*"
    }
  ]
}
POLICY

  tags {
    Name        = "${var.name}"
    Environment = "${var.envname}"
    Service     = "${var.service}"
    Envtype     = "${var.envtype}"
  }
}

resource "aws_alb" "alb" {
  name            = "${var.name}-${var.envname}-alb"
  internal        = "${var.alb_internal}"
  security_groups = ["${var.alb_security_groups}"]
  subnets         = ["${var.alb_subnets}"]

  access_logs {
    bucket = "${aws_s3_bucket.alb_log_bucket.id}"
    prefix = "${var.log_s3prefix}"
  }

  tags {
    Name    = "${var.name}"
    Envname = "${var.envname}"
    EnvType = "${var.envtype}"
    Service = "${var.service}"
  }
}

resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.listener_port_1}"
  protocol          = "${var.listener_protocol_1}"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.certificate_id}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.listener_port_2}"
  protocol          = "${var.listener_protocol_2}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_https" {
  listener_arn = "${aws_alb_listener.alb_listener_https.arn}"
  priority     = "${var.listener_priority_1}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["${var.path_value}"]
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule_http" {
  listener_arn = "${aws_alb_listener.alb_listener_http.arn}"
  priority     = "${var.listener_priority_2}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["${var.path_value}"]
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name     = "${var.name}-${var.envname}-tg"
  port     = "${var.target_port}"
  protocol = "${var.target_protocol}"
  vpc_id   = "${var.vpc_id}"

  deregistration_delay = "${var.deregistration_delay}"

  stickiness {
    type            = "lb_cookie"
    cookie_duration = "${var.cookie_duration}"
    enabled         = "${var.stickiness_enabled}"
  }

  health_check {
    interval            = "${var.health_check_interval}"
    path                = "${var.health_check_path}"
    protocol            = "${var.target_protocol}"
    timeout             = "${var.health_check_timeout}"
    healthy_threshold   = "${var.healthy_threshold}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
    matcher             = "${var.health_check_matcher}"
  }
}

// Launch Configuration
resource "aws_launch_configuration" "lc" {
  lifecycle {
    create_before_destroy = true
  }

  security_groups = ["${var.security_groups}"]

  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  key_name                    = "${var.key_name}"
  user_data                   = "${var.user_data}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  enable_monitoring           = "${var.detailed_monitoring}"
}

// Auto-Scaling Group Configuration
resource "aws_autoscaling_group" "asg" {
  name                = "${var.name}"
  availability_zones  = ["${var.availability_zones}"]
  vpc_zone_identifier = ["${var.subnets}"]

  // Use the Name from the launch config created above
  launch_configuration = "${aws_launch_configuration.lc.name}"

  min_size = "${var.asg_min}"
  max_size = "${var.asg_max}"

  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.health_check_type}"
  target_group_arns         = ["${aws_alb_target_group.alb_target_group.arn}"]

  tag {
    key = "Name"

    value = "${var.name}"

    propagate_at_launch = true
  }

  tag {
    key = "Environment"

    value = "${var.envname}"

    propagate_at_launch = true
  }

  tag {
    key = "Service"

    value = "${var.service}"

    propagate_at_launch = true
  }

  tag {
    key = "Envtype"

    value = "${var.envtype}"

    propagate_at_launch = true
  }
}
