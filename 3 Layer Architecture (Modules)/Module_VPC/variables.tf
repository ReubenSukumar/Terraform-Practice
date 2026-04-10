variable "CIDR" {
  description = "Define the CIDR block of the VPC:"                               # VPC CIDR block variable
  type = string
}

variable "Public_Subnet_1" {
  description = "Define the CIDR block for Public Subnet Zone-1:"                 # Public Subnet-1 CIDR block variable
  type = string
}

variable "Public_Subnet_2" {
  description = "Define the CIDR block for Public Subnet Zone-2:"                 # Public Subnet-2 CIDR block variable
  type = string
}

variable "Private_Subnet_1" {
  description = "Define the CIDR block for Private Subnet Zone-1:"                # Private Subnet-1 CIDR block variable
  type = string
}

variable "Private_Subnet_2" {
  description = "Define the CIDR block for Private Subnet Zone-2:"                # Private Subnet-2 CIDR block variable
  type = string
}

variable "Private_DB_Subnet_1" {
  description = "Define the CIDR block for Private-DB Subnet Zone-1:"             # Private DB Subnet-1 CIDR block variable
  type = string
}

variable "Private_DB_Subnet_2" {
  description = "Define the CIDR block for Private-DB Subnet Zone-2:"             # Private DB Subnet-2 CIDR block variable
  type = string
}

variable "Public_Interface_id" {
  description = "Public Instance 1a Primary Network Interface ID"                 # Public Instance-1 Network Interface ID variable required for main.tf in Module_VPC
}