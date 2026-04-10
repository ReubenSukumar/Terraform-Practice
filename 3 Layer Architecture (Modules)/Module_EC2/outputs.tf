output "Public_Instance_IPs" {
  value = {
    "1a" = {
        Public_IP = aws_instance.T_Public_Instance_1a.public_ip                           # Display Public IPs
        Private_IP = aws_instance.T_Public_Instance_1a.private_ip

    }
    "1b" = {
        Public_IP = aws_instance.T_Public_Instance_1b.public_ip
        Private_IP = aws_instance.T_Public_Instance_1b.private_ip
    }
  }
}

output "Private_Instance_IPs" {
  value = {
    "1a" = {
      Private_Instance_1 = aws_instance.T_Private_Instance_1a.private_ip                  # Display Private IPs
      Master_Instance = aws_instance.T_DB_Private_Instance_1a.private_ip
    }

    "1b" = {
      Private_Instance_2 = aws_instance.T_Private_Instance_1b.private_ip
      Slave_Instance = aws_instance.T_DB_Private_Instance_1b.private_ip      
    }
  }
}

output "Public_Instance_Name" {
  value = {
    "1a" = {
        Name = aws_instance.T_Public_Instance_1a.tags["Name"]                             # Display Public Instance Names
    }
    "1b" = {
        Name = aws_instance.T_Public_Instance_1b.tags["Name"]
    }
  }
}

output "Private_Instance_Name" {
  value = {
    "1a" = {
        Private_Instance_Name_1 = aws_instance.T_Private_Instance_1a.tags["Name"]
        Private_DB_Instance_Name_1 = aws_instance.T_DB_Private_Instance_1a.tags["Name"]    
    }                                                                                     # Display Private Instance Names
    "1b" = {
        Private_Instance_Name_2 = aws_instance.T_Private_Instance_1b.tags["Name"]
        Private_DB_Instance_Name_2 = aws_instance.T_DB_Private_Instance_1b.tags["Name"]
    }
  }
}

output "Public_Instance_1_ID"{
  description = "Public Instance - 1 ID"
  value = aws_instance.T_Public_Instance_1a.id                                    # Public Instance-1 ID required for main.tf in Module_ALB_and_TG

}

output "Public_Instance_2_ID"{
  description = "Public Instance - 2 ID"
  value = aws_instance.T_Public_Instance_1b.id                                    # Public Instance-2 ID required for main.tf in Module_ALB_and_TG
}

output "Private_Instance_1_ID"{
  description = "Private Instance - 1 ID"
  value = aws_instance.T_Private_Instance_1a.id                                   # Private Instance-1 ID required for main.tf in Module_ALB_and_TG
}

output "Private_Instance_2_ID"{
  description = "Private Instance - 2 ID"
  value = aws_instance.T_Private_Instance_1b.id                                   # Private Instance-2 ID required for main.tf in Module_ALB_and_TG
}

output "Public_Interface_ID" {
  description = "Public Instance 1a Primary Network Interface ID"
  value = aws_instance.T_Public_Instance_1a.primary_network_interface_id          # Public Instance-1 Network Interface ID required for main.tf in Module_VPC
}