variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "key_name" {
  type        = string
  default     = ""
  description = "Optional: EC2 key pair name. Leave empty if using SSM only."
}

variable "app_repo" {
  type        = string
  default     = ""
  description = "Optional GitHub repo URL (must be public)."
}

variable "app_dir" {
  type        = string
  default     = "app"
  description = "App folder name inside the repo."
}
