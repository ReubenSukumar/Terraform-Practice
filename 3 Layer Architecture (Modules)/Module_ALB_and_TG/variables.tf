variable "Public_ALB_Name" {
  description = "Name of Public ALB:"
  type = string
}

variable "Private_ALB_Name" {
  description = "Name of Private ALB:"
  type = string
}

variable "public_subnets" {
  description = "Subnet ID of Public Instances"       # Public Subnet IDs variable required for main.tf in Module_ALB_and_TG
  type = list(string)
}

variable "private_subnets" {
  description = "Subnet ID of Private Instances"      # Private Subnet IDs variable required for main.tf in Module_ALB_and_TG
  type = list(string)
}

variable "vpc_id" {
  description = "ID of VPC"                           # VPC ID variable required for main.tf in Module_ALB_and_TG
  type = string
}

variable "public_1_instance_id" {
  description = "Public Instance - 1 ID"              # Public Instance-1 ID variable required for main.tf in Module_ALB_and_TG
  type = string
}

variable "public_2_instance_id" {
  description = "Public Instance - 2 ID"              # Public Instance-2 ID variable required for main.tf in Module_ALB_and_TG
}

variable "private_1_instance_id" {
  description = "Private Instance - 1 ID"             # Private Instance-1 ID variable required for main.tf in Module_ALB_and_TG
  type = string
}

variable "private_2_instance_id" {
  description = "Private Instance - 2 ID"             # Private Instance-2 ID variable required for main.tf in Module_ALB_and_TG
}

variable "public_alb_id" {
  description = "Public ALB Security Group"           # Public ALB ID variable required for main.tf in Module_ALB_and_TG
}

variable "private_alb_id" {
  description = "Private ALB Security Group"          # Private ALB ID variable required for main.tf in Module_ALB_and_TG
}