🚀 Terraform AWS VPC Multi-Tier Network Setup

This project demonstrates how to provision a custom AWS VPC with public and private subnets across multiple Availability Zones using Terraform.

It follows best practices such as network segmentation, route table design, and multi-AZ architecture, which are foundational for production-grade cloud environments.

📁 Project Structure
```text
VPC creation (Terraform)/
│
├── main.tf                    # Complete VPC + networking resources
├── README.md                  # Project documentation
├── .gitignore                 # Git ignore rules
│
├── .terraform/                # Terraform internal files (auto-generated)
├── terraform.tfstate          # Terraform state file
├── terraform.tfstate.backup   # Backup state file
├── .terraform.lock.hcl        # Provider lock file
```
🧱 Architecture Overview

This setup creates a 2-tier VPC architecture across 2 Availability Zones:
```text
VPC (20.0.0.0/16)
│
├── 🌐 Public Subnets
│   ├── 20.0.1.0/24 (us-east-1a)
│   ├── 20.0.2.0/24 (us-east-1b)
│   └── Route → Internet Gateway
│
├── 🔒 Private Subnets
│   ├── 20.0.3.0/24 (us-east-1a)
│   ├── 20.0.4.0/24 (us-east-1b)
│   └── No Internet access (isolated)
│
├── 🌍 Internet Gateway
│
├── 📡 Public Route Table
│   └── 0.0.0.0/0 → IGW
│
└── 🛑 Private Route Table
    └── No default route (can be extended with NAT)
```

⚙️ Resources Created
```text
🔹 Core Networking
Resource Type              Description
aws_vpc                    Custom VPC (20.0.0.0/16)
aws_internet_gateway       Enables internet access
```
🔹 Subnets
```text
Public Subnets:
- vpc-sub-public-1 (us-east-1a)
- vpc-sub-public-2 (us-east-1b)

Private Subnets:
- vpc-sub-private-1 (us-east-1a)
- vpc-sub-private-2 (us-east-1b)
```
✔ Public subnets:

Auto-assign public IP enabled
Used for ALB, Bastion, Frontend

✔ Private subnets:

No public IP
Used for backend, DB
🔹 Route Tables
```text
Route Table              Purpose
vpc-public-rt            Internet access via IGW
vpc-private-rt           Isolated (no internet)
```

✔ Public Route:
```text
0.0.0.0/0 → Internet Gateway
```

✔ Private Route:
```text
(No route to internet)
```
🔹 Route Table Associations
```text
Public:
- Public-1 → Public RT
- Public-2 → Public RT

Private:
- Private-1 → Private RT
- Private-2 → Private RT
```
⚙️ Prerequisites
```text
Terraform installed
AWS CLI configured
IAM user with VPC permissions
```

Setup AWS CLI:
```text
aws configure
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
5️⃣ Destroy Resources (Optional)
```text
terraform destroy
```
⚠️ Important Notes

✔ CIDR blocks must not overlap
✔ Ensure correct Availability Zones (us-east-1a, us-east-1b)
✔ Public subnets must have:
```text
map_public_ip_on_launch = true
```
✔ Private subnets:
```text
map_public_ip_on_launch = false
```
🔥 Future Enhancements (Recommended)

This setup is foundation-level, you can extend it like your johnwick.online architecture:

➕ Add NAT Gateway (for private subnet internet)
```text
Private Subnet → NAT Gateway → Internet
```
➕ Add Security Groups
```text
Allow HTTP/HTTPS, SSH, backend ports
```
➕ Add ALB (Application Load Balancer)
```text
Public Subnet → ALB → Private Backend
```
➕ Add Auto Scaling Group
```text
Backend instances in private subnets
```
🐞 Troubleshooting
❌ Provider Download Error
Failed to install provider

✅ Fix:
```text
rm -rf .terraform
rm .terraform.lock.hcl
terraform init
```
❌ Subnet Not Accessible from Internet

✔ Check:
```text
- Internet Gateway attached to VPC
- Route table has 0.0.0.0/0 → IGW
- Subnet associated with public RT
```
❌ Instances in Private Subnet Cannot Access Internet

✔ Expected behavior ❗
👉 Fix by adding:

NAT Gateway + Route
❌ Wrong AZ Error

✔ Ensure:
```text
availability_zone = "us-east-1a"
availability_zone = "us-east-1b"
```
💡 Key Learnings
```text
VPC creation using Terraform

Public vs Private subnet design

Route tables & associations

Multi-AZ architecture

Internet Gateway usage
```
Network isolation principles


👨‍💻 **Author**

**Reuben**
**DevOps / Cloud Enthusiast 🚀**