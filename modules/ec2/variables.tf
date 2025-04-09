variable "ami_id" {
  type        = string
  description = "AMI to use for EC2 instances"
}

variable "key_name" {
  type        = string
  description = "SSH key name"
}

variable "private_key_path" {
  type        = string
  description = "Path to the private key file"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "proxy_sg_id" {
  type        = string
  description = "Security Group ID for proxy EC2 instances"
}

variable "apache_sg_id" {
  type        = string
  description = "Security Group ID for apache EC2 instances"
}

variable "private_alb_dns" {
  description = "DNS name of the private ALB to forward traffic to"
  type        = string
}

