variable "key_pair" {
  description = "Provide the key pair to be used"
  type = string
}

variable "assign_public_ip" {
  description = "Auto assign Public IP"
  type = bool
}

variable "EC2_name" {
  description = "Enter the EC2 name"
  type = string
}
