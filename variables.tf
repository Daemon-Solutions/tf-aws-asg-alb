// Environment variables
variable "name" {
  description = "The desired name prefix for your ASG resources. Will also be added as the value for the 'Name' tag"
  type = "string"
}

variable "envname" {
  description = "This will become the value for the 'Environment' tag on resources created by this module"
  type = "string"
}

variable "envtype" {
  description = "This will become the value for the 'Envtype' tag on resources created by this module"
  type = "string"
}

variable "service" {
  description = "This will become the value for the 'Service' tag on resources created by this module"
  type = "string"
}

// DNS variables
variable "alb_internal" {
  description = "Bool indicating whether the ALB is internal"
  type = "string"
  default = false
}

variable "alb_dns" {
  description = "Count of how many ALB DNS aliases to create"
  type = "string"
  default = "0"
}

variable "route53_zone_id" {
  description = "The ID for the route 53 zone where DNS for for this ALB will be held"
  type = "string"
}

variable "domain" {
  description = "The fully qualified domain name for DNS records for this ALB"
  type = "string"
  default = "example.com"
}

// ALB variables
variable "region" {
  description = "The AWS region to create this ALB in"
  type = "string"
  default = "eu-west-1"
}

variable "vpc_id" {
  description = "The ID for the VPC to create this ALB in"
  type = "string"
}

variable "alb_security_groups" {
  description = "A list of security group IDs to assign to the ALB"
  type = "list"
  default = []
}

variable "alb_subnets" {
  description = "A list of subnet IDs to attach to the ALB"
  type = "list"
}

variable "log_s3bucket" {
  description = "This name will be used in addition to the 'name' prefix to create the logs storage bucket"
  type = "string"
  default = "alb-log-storage"
}

variable "log_s3prefix" {
  description = "The folder in which to store the ALB logs in the storage bucket"
  type = "string"
  default = "ALB"
}

variable "alb_aws_account" {
  description = "The stock ALB ARNs for the ALB service, used to allow write access to the log bucket"
  type = "map"
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
  description = "Port #1 for the ALB to listen on"
  type = "string"
  default = "443"
}

variable "listener_protocol_1" {
  description = "Protocol #1 for the ALB to listen on"
  type = "string"
  default = "HTTPS"
}

variable "listener_port_2" {
  description = "Port #2 for the ALB to listen on"
  type = "string"
  default = "80"
}

variable "listener_protocol_2" {
  description = "Protocol #2 for the ALB to listen on"
  type = "string"
  default = "HTTP"
}

variable "certificate_id" {
  description = "The ARN for a TLS certificate to use for the ALB listener"
  type = "string"
}

variable "listener_priority_1" {
  description = "The priority for the first listener rule"
  type = "string"
  default = "100"
}

variable "listener_priority_2" {
  description = "The priority for the second listener rule"
  type = "string"
  default = "200"
}

variable "path_value" {
  description = "The path patterns to match for this ALB"
  type = "string"
  default = "*"
}

variable "target_port" {
  description = "The port to target on the backend service for this ALB"
  type = "string"
  default = "443"
}

variable "target_protocol" {
  description = "The protocol to connect to the backend service with"
  type = "string"
  default = "HTTP"
}

variable "deregistration_delay" {
  description = "The amount time for the ALB to wait before changing the state of a deregistering target from draining to unused"
  type = "string"
  default = "300"
}

variable "cookie_duration" {
  description = "The lifetime (seconds) of ALB issued cookies"
  type = "string"
  default = "86400"
}

variable "stickiness_enabled" {
  description = "Bool indicating whether to enable session affinity on the ALB"
  type = "string"
  default = true
}

variable "health_check_interval" {
  description = "The approximate amount of time (seconds) between health checks of an individual target"
  type = "string"
  default = "30"
}

variable "health_check_path" {
  description = "The destination for the health check request"
  type = "string"
  default = "/"
}

variable "health_check_timeout" {
  description = "The amount of time (seconds) during which no response means a failed health check"
  type = "string"
  default = "5"
}

variable "healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
  type = "string"
  default = "5"
}

variable "unhealthy_threshold" {
  description = "The number of consecutive health checks successes required before considering a healthy target unhealthy"
  type = "string"
  default = "2"
}

variable "health_check_matcher" {
  description = "The HTTP codes to use when checking for a successful response from a target"
  type = "string"
  default = "200"
}

variable "health_check_type" {
  description = "Controls how health checking is done (ELB or EC2)"
  type = "string"
  default = "ELB"
}

variable "health_check_grace_period" {
  description = "Time (seconds) after instance comes into service before checking health"
  type = "string"
  default = "300"
}

// Launch Configuration Variables
variable "instance_type" {
  description = "The instance type to select when the ASG launches new instances"
  type = "string"
  default = "t2.micro"
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with launched instances"
  type = "string"
}

variable "key_name" {
  description = "The key pair to associate with launched instances"
  type = "string"
}

variable "security_groups" {
  description = "A list of associated security group IDs"
  type = "list"
}

variable "user_data" {
  description = "Content of user_data file"
  type = "string"
}

variable "associate_public_ip_address" {
  description = "Bool indicating whether to associate a public IP with ASG launched instances"
  type = "string"
  default = false
}

variable "detailed_monitoring" {
  description = "Bool indicating whether to enable detailed monitoring"
  type = "string"
  default = false
}

// Auto-Scaling Group
variable "availability_zones" {
  description = "List of availability zones to spread resources across"
  type = "list"
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the ALB"
  type = "list"
}

variable "asg_min" {
  description = "Minimum number of instances for the ASG to maintain"
  type = "string"
  default = 0
}

variable "asg_max" {
  description = "Maximum number of instances for the ASG to maintain"
  type = "string"
  default = 1
}

variable "ami_id" {
  description = "The ID of the AMI to select for ASG launched instances"
  type = "string"
}
