variable "key_pair" {
  description = "Mention the key pair name"
  type = string
}

variable "auto_public_ip" {
  description = "Should Assign Public IP be enabled"
  type = bool
}

variable "EC2_name"{
    description = "Enter the EC2 Instance name"
    type = string
}