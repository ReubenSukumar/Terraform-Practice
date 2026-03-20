🚀 Terraform EC2 Deployment with Remote Backend (S3)

This project demonstrates how to provision an AWS EC2 instance using Terraform modules while storing the Terraform state remotely in an S3 backend.

It follows best practices such as:

Modular infrastructure design

Remote state management

Parameterized configuration using variables

Clean project structure

📁 Project Structure

```text
EC2 instance creation (Remote Backend)/
│
├── main.tf                     # Root module (calls EC2 module)
├── backend.tf                  # S3 backend configuration
├── README.md                   # Documentation
├── .terraform.lock.hcl         # Provider lock file
│
├── Module_EC2/                 # Reusable EC2 module
│   ├── main.tf                 # EC2 resource definition
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│
├── .terraform/                 # Terraform internal files (auto-generated)
```

🧱 Architecture Overview

Root module calls a reusable EC2 module

Module provisions:

EC2 Instance

Key pair assignment

Public IP configuration

Tagging

Terraform state is stored remotely in S3

Infrastructure is parameterized using variables

⚙️ Prerequisites

Make sure you have:

✅ Terraform installed

✅ AWS CLI configured
```text
aws configure
```
✅ IAM user with required permissions:

EC2 access

S3 access

☁️ Remote Backend Configuration (S3)

Terraform state is stored in S3:
```text
terraform {
  backend "s3" {
    bucket = "terraform-fail-safe"
    key    = "State Folder/terraform.tfstate"
    region = "ap-south-1"
  }
}
```

🔑 Why Remote Backend?

Prevents state loss

Enables team collaboration

Centralized state management

📦 Module Usage (Root Module)

```text
module "Testing_Instance" {
  source         = "./Module_EC2"
  key_pair       = "Treasure"
  auto_public_ip = true
  EC2_name       = "Terra-Instance"
}
```

🖥️ EC2 Configuration (Module)
```text
resource "aws_instance" "Testing_Instance" {
  ami                         = "ami-0b6c6ebed2801a5cb"
  instance_type               = "t3.micro"
  security_groups             = ["sg-0e15788c553654321"]
  subnet_id                   = "subnet-04bc3d5190e987654"
  key_name                    = var.key_pair
  associate_public_ip_address = var.auto_public_ip

  tags = {
    Name = var.EC2_name
  }
}
```
🔑 Input Variables
```text
Variable	Description	Type
key_pair	EC2 Key Pair name	string
auto_public_ip	Assign public IP	bool
EC2_name	Name tag for EC2 instance	string
```
📤 Outputs
```text
Output Name	Description
Private_IP_Address	EC2 private IP address
Public_IP_Address	EC2 public IP address
```
🚀 How to Deploy
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
🔒 State Locking (Important Note)

Currently, only S3 backend is configured.

👉 For production:

Add S3 native lockfile for state locking

Example:

use_lockfile = true

Ensure:

Security Group exists

Subnet exists

Key pair exists

AMI must be valid in the selected region

Backend S3 bucket must be created before running terraform init

🧪 Best Practices Used

✔ Modular Terraform design

✔ Remote backend (S3)

✔ Variable abstraction

✔ Clean directory structure

📌 Future Enhancements

Add backend locking

Use .tfvars for environment-specific configs

Add support for multiple EC2 instances

Integrate with CI/CD (GitHub Actions)

👨‍💻 **Author**

**Reuben**
**DevOps / Cloud Enthusiast 🚀**