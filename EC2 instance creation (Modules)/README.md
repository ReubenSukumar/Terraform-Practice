🚀 Terraform EC2 Deployment using Modules

This project demonstrates how to provision an AWS EC2 instance using Terraform Modules, following best practices such as modularization, variable abstraction, and reusable infrastructure components.

📁 Project Structure

```text
EC2 instance creation (Modules)/
│
├── main.tf                    # Root module (calls EC2 module)
├── outputs.tf                 # Root outputs (exposes module outputs)
├── README.md                  # Project documentation
├── .gitignore                 # Git ignore rules
│
├── EC2_Module/                # Reusable EC2 module
│   ├── main.tf                # EC2 resource definition
│   ├── variables.tf           # Module input variables
│   ├── outputs.tf             # Module outputs (private IP, etc.)
│
├── .terraform/                # Terraform internal files (auto-generated)
├── terraform.tfstate          # Terraform state file
├── terraform.tfstate.backup   # Backup state file
├── .terraform.lock.hcl        # Provider lock file
```

🧱 Architecture Overview

Root module invokes a custom EC2 module

Module handles:
```text
EC2 creation

Key pair assignment

Public IP configuration

Tagging

Variables are passed from root → module

Outputs are passed from module → root
```

⚙️ Prerequisites

Terraform installed

AWS CLI configured:

aws configure

IAM user with EC2 permissions

Existing AWS Resources Required:

VPC

Subnet

Security Group

Key Pair

📦 Module: EC2_Module
🔹 Variables (variables.tf)
```text
Variable             Type    Description
key_pair             string  EC2 key pair name
assign_public_ip     bool    Assign public IP
EC2_name             string  EC2 instance name tag
```
🔹 Resource (main.tf)

Creates an EC2 instance with:

AMI (Free Tier eligible)

Instance type: t3.micro

Subnet & Security Group (pre-created)

Key pair

Optional public IP

Name tag from variable

🔹 Outputs (outputs.tf)
```text
output "private_ip_address" {
  value = aws_instance.Trial_Instance.private_ip
}
```
🧩 Root Module Usage
```text
module "Trial_Instance" {
  source            = "./EC2_Module"
  key_pair          = "Treasure"
  EC2_name          = "Terraform-Instance-Module-1"
  assign_public_ip  = true
}
```
📤 Root Outputs

To expose module outputs, define in root outputs.tf:
```text
output "private_ip_address" {
  value = module.Trial_Instance.private_ip_address
}
```
🚀 How to Run
1️⃣ Initialize Terraform

```text
terraform init
```
2️⃣ Validate Configuration

```text
terraform validate
```
3️⃣ Plan Deployment

```text
terraform plan
```
4️⃣ Apply Changes

```text
terraform apply
```
5️⃣ View Outputs

```text
terraform output
```

6️⃣ Destroy Resources (Optional)

```text
terraform destroy
```

⚠️ Important Notes

Ensure correct values for:

```text
subnet_id

vpc_security_group_ids

Use full IDs (not truncated)
```

Replace:

security_groups

with:
```text
vpc_security_group_ids

🐞 Troubleshooting
❌ Provider Download Error
```
If you face:
```text
Failed to install provider
wsarecv: An existing connection was forcibly closed

👉 Fix:

Retry terraform init

Switch network / disable VPN

Clear cache:
```text
rm -rf .terraform
rm .terraform.lock.hcl
terraform init
```

```text
❌ Boolean Variable Error
assign_public_ip = "True" ❌
```

✅ Correct:

```text
assign_public_ip = true
❌ Output Not Showing

If outputs are not displayed:

Ensure output is defined in module
```
Re-export output in root module

Example:
```text
value = module.Trial_Instance.private_ip_address
```
Run:
```text
terraform apply

```
💡 Key Learnings

Terraform Modules for reusable infrastructure

Variable abstraction and type safety

Root vs Child module separation

Output propagation (Module → Root)

AWS EC2 provisioning via IaC




👨‍💻 **Author**

**Reuben**
**DevOps / Cloud Enthusiast 🚀**