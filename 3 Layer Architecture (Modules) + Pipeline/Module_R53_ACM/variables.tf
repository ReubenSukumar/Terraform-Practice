variable "Domain_Name" {
  description = "Define the Domain Name"                               # Domain Name variable
  type = string
}

variable "Certificate_Name" {
  description = "Define the Certificate Name"                               # Domain Name variable
  type = string
}

variable "public_alb_dns" {
  description = "PubliC ALB DNS for R53"
}

variable "public_alb_zone" {
  description = "PubliC ALB Zone ID for R53"
}