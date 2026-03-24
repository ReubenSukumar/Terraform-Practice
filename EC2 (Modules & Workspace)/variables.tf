variable "ecname" {
  type        = string
  description = "Enter the instance name please"
}

variable "key-name" {
  type        = string
  description = "Provide the key name please"
}

variable "pub-ip" {
  type        = bool
  description = "Auto assign public IP?"
}
