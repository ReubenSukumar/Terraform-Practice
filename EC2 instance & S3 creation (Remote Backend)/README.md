🚀 Terraform AWS Deployment using Modules + Remote Backend

This project demonstrates how to provision AWS infrastructure using Terraform Modules, including:

->EC2 instance deployment

->S3 bucket creation (for backend state)

->Remote state management using S3 backend

The setup follows best practices such as modularization, reusable infrastructure components, and separation of backend configuration from resource definitions.

📁 Project Structure

```text
Terraform-AWS-Modules/
│
├── main.tf                    # Root module (calls EC2 & S3 modules)
├── backend.tf                 # Remote backend configuration (S3)
├── variables.tf               # Root input variables
├── outputs.tf                 # Root outputs
├── terraform.tfvars           # Variable values
├── README.md                  # Project documentation
├── .gitignore                 # Git ignore rules
│
├── modules/
│   ├── ec2/
│   │   ├── main.tf            # EC2 resource definition
│   │   ├── variables.tf       # EC2 input variables
│   │   ├── outputs.tf         # EC2 outputs (IP, etc.)
│   │
│   ├── s3/
│       ├── main.tf            # S3 bucket creation (backend infra)
│       ├── variables.tf       # S3 input variables
│       ├── outputs.tf         # S3 outputs (bucket name)
│
├── .terraform/                # Terraform internal files (auto-generated)
├── terraform.tfstate          # Local state (initial phase)
├── terraform.tfstate.backup   # Backup state file
├── .terraform.lock.hcl        # Provider lock file
```

🧱 Architecture Overview

Root module invokes two reusable modules:

🔹 S3 Module

Creates S3 bucket for storing Terraform state

Acts as backend infrastructure (bootstrap)

🔹 EC2 Module

Provisions EC2 instance

Handles:

```text
AMI selection

Instance type

Key pair assignment

Subnet & Security Group association

Public IP configuration

Tagging
```
🔹 Backend Configuration
```text
S3 backend stores Terraform state remotely

Ensures centralized state management

(No DynamoDB locking used – testing purpose)
```
⚙️ Prerequisites

Terraform installed

AWS CLI configured:
```text
aws configure
```
IAM user with:
```text
EC2 permissions
```

S3 permissions
📦 Modules Overview
🔹 EC2 Module

Handles EC2 provisioning using input variables.

Inputs

```text
Variable             Description
key_pair             EC2 key pair name
auto_public_ip       Assign public IP
EC2_name             Instance name tag
```
Outputs

```text
Private IP address

Public IP (if enabled)
```

🔹 S3 Module (Backend Infra)

Responsible for creating S3 bucket used for Terraform backend.

Inputs
```text
Variable             Description
bucket_name          Globally unique S3 bucket name
```

Outputs
```text
Bucket name
```

🧩 Root Module Usage

Root module connects everything together:
```text
Calls S3 module → creates backend bucket

Calls EC2 module → provisions compute resource

Defines backend configuration separately
```

🌐 Backend Configuration
```text
Remote backend is configured using S3

State file is stored in S3 bucket

Key defines path of state file

Region must match bucket region
```

⚠️ Note:
```text
Backend is initialized before modules

So bucket must exist before enabling backend

Requires a two-step setup (bootstrap → backend)
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
🔁 Backend Migration (After S3 Creation)

Once S3 bucket is created:
```text
terraform init -reconfigure
```

👉 Terraform will prompt to migrate state → select yes

5️⃣ View Outputs
```text
terraform output
```
6️⃣ Destroy Resources (Optional)
```text
terraform destroy
```
⚠️ Important Notes

S3 bucket names must be:
```text
Globally unique

Lowercase only
```

Backend cannot:
```text
Use variables

Use module outputs

Be defined inside modules
```

Backend must be defined in:
```text
Root module only
```

🐞 Troubleshooting
❌ Backend Initialization Error

If backend fails to initialize:
```text
terraform init -reconfigure
```
Or clear cache:
```text
rm -rf .terraform
rm .terraform.lock.hcl
terraform init
```
❌ Bucket Already Exists
```text
Error: BucketAlreadyExists
```
👉 Fix:
```text
Use a globally unique bucket name
```
❌ Provider Download Error
```text
wsarecv: connection forcibly closed
```
👉 Fix:
```text
Retry terraform init

Switch network / disable VPN

Clear .terraform folder
```

❌ State Not Migrated

If state is still local:
```text
terraform init -reconfigure
```
💡 Key Learnings

Terraform Modules for reusable infrastructure

Separation of backend and resources

Backend initialization lifecycle

Remote state management using S3

Root vs Child module design

Two-phase Terraform workflow (bootstrap → backend)

👨‍💻 **Author**

**Reuben**
**DevOps / Cloud Enthusiast 🚀**