variable "pem" {
  description = "Provide the key-pair value"
  type = string
}

variable "EC2_name" {
  description = "Provide the Instance Name"
  type = string
}

variable "auto_ip" {
  description = "Should the Auto assign public IP be true/false?"
  type = bool
}