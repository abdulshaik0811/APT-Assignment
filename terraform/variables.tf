variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resources"
  type        = string
  default     = "terraform-alb-asg"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "ASG desired capacity"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "ASG maximum size"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "ASG minimum size"
  type        = number
  default     = 1
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = ""
}
