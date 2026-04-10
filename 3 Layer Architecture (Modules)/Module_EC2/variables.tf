variable "Pem_Name" {
  description = "Name of .pem File:"
  type = string
}

variable "Public_Instance_1" {
  description = "Name of Public Instance in Zone-1:"
  type = string
}

variable "Public_Instance_2" {
  description = "Name of Public Instance in Zone-2:"
  type = string
}

variable "Private_Instance_1" {
  description = "Name of Private Instance in Zone-1:"
  type = string
}

variable "Private_Instance_2" {
  description = "Name of Private Instance in Zone-2:"
  type = string
}

variable "Private_DB_Instance_1" {
  description = "Name of Private DB Instance in Zone-1:"
  type = string
}

variable "Private_DB_Instance_2" {
  description = "Name of Private DB Instance in Zone-2:"
  type = string
}

variable "Public_Instance_sg" {
  description = "Public Instance Security Group"                        # Public Instance SG ID variable required for main.tf in Module_EC2
}

variable "Private_Instance_sg" {
  description = "Private Instance Security Group"                       # Private Instance SG ID variable required for main.tf in Module_EC2
}

variable "Master_Instance_sg" {
  description = "Master Server Security Group"                          # Master Instance SG ID variable required for main.tf in Module_EC2
}

variable "Slave_Instance_sg" {
  description = "Slave Server Security Group"                           # Slave Instance SG ID variable required for main.tf in Module_EC2
}

variable "Public_Subnet_1_id" {
  description = "Public Instance - 1 Subnet ID"                         # Public Instance-1 subnet ID variable required for main.tf in Module_EC2
}

variable "Public_Subnet_2_id" {
  description = "Public Instance - 2 Subnet ID"                         # Public Instance-2 subnet ID variable required for main.tf in Module_EC2
}

variable "Private_Subnet_1_id" {
  description = "Private Instance - 1 Subnet ID"                        # Private Instance-1 subnet ID variable required for main.tf in Module_EC2
}

variable "Private_Subnet_2_id" {
  description = "Private Instance - 2 Subnet ID"                        # Private Instance-2 subnet ID variable required for main.tf in Module_EC2
}

variable "DB_Subnet_1_id" {
  description = "Master Instance - 2 Subnet ID"                         # Master DB Instance subnet ID variable required for main.tf in Module_EC2
}

variable "DB_Subnet_2_id" {
  description = "Slave Instance - 2 Subnet ID"                          # Slave DB Instance subnet ID variable required for main.tf in Module_EC2
}

variable "private_alb_for_script" {
  description = "Public ALB DNS Name"                                   # Public ALB DNS variable required for main.tf in Module_EC2
}
