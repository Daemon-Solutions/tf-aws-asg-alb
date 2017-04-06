// environment variables
variable "name" {}
variable "envname" {}
variable "envtype" {}
variable "service" {}

// dns variables
variable "alb_internal" {
  default = false
}

variable "alb_dns" {
  default = "0"
}

variable "route53_zone_id" {
  default = "changeme"
}

variable "domain" {
  default = "example.com"
}

// alb variables
variable "region" {
  default = "eu-west-1"
}

variable "vpc_id" {}

variable "alb_security_groups" {
  type = "list"
}

variable "alb_subnets" {
  type = "list"
}

variable "log_s3bucket" {}

variable "log_s3prefix" {
  default = "ALB"
}

variable "alb_aws_account" {
  default = {
    us-east-1      = "127311923021"
    us-east-2      = "033677994240"
    us-west-1      = "027434742980"
    us-west-2      = "797873946194"
    ca-central-1   = "985666609251"
    eu-west-1      = "156460612806"
    eu-central-1   = "054676820928"
    eu-west-2      = "652711504416"
    ap-northeast-1 = "582318560864"
    ap-northeast-2 = "600734575887"
    ap-southeast-1 = "114774131450"
    ap-southeast-2 = "783225319266"
    sa-east-1      = "507241528517"
    us-gov-west-1  = "048591011584"
    cn-north-1     = "638102146993"
  }
}

variable "listener_port_1" {
  default = "443"
}

variable "listener_protocol_1" {
  default = "HTTPS"
}

variable "listener_port_2" {
  default = "80"
}

variable "listener_protocol_2" {
  default = "HTTP"
}

variable "certificate_id" {}

variable "listener_priority_1" {
  default = "100"
}

variable "listener_priority_2" {
  default = "200"
}

variable "path_value" {
  default = "*"
}

variable "target_port" {
  default = "80"
}

variable "target_protocol" {
  default = "HTTP"
}

variable "deregistration_delay" {
  default = "300"
}

variable "cookie_duration" {
  default = "86400"
}

variable "stickiness_enabled" {
  default = true
}

variable "health_check_interval" {
  default = "30"
}

variable "health_check_path" {
  default = "/"
}

variable "health_check_timeout" {
  default = "5"
}

variable "healthy_threshold" {
  default = "5"
}

variable "unhealthy_threshold" {
  default = "2"
}

variable "health_check_matcher" {
  default = "200"
}

variable "health_check_type" {
  default = "ELB"
}

variable "health_check_grace_period" {
  default = "300"
}

// Launch Configuration Variables

variable "instance_type" {
  default = "t2.micro"
}

variable "iam_instance_profile" {}
variable "key_name" {}

variable "security_groups" {
  type = "list"
}

variable "user_data" {
  description = "Content of user_data file"
}

variable "associate_public_ip_address" {
  default = false
}

variable "detailed_monitoring" {
  default = false
}

// Auto-Scaling Group
variable "availability_zones" {
  type = "list"
}

variable "subnets" {
  type = "list"
}

variable "asg_min" {
  default = 0
}

variable "asg_max" {
  default = 1
}

variable "ami_id" {}
