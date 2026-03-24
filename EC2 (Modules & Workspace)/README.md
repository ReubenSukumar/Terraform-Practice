🚀 Terraform EC2 Deployment using Modules & Workspaces

This project demonstrates how to provision AWS EC2 instances using Terraform Modules, along with environment-specific configurations using .tfvars files and a remote backend for state management.

It follows best practices such as modularization, reusable infrastructure, and separation of environments (Dev/Test).

📁 Project Structure
```text
EC2 (Modules & Workspace)/
│
├── Module_EC2/                 # Reusable EC2 module
│   ├── main.tf
│   ├── variables.tf
│   └── output.tf
│
├── terraform/                  # Terraform working directory (auto-generated)
├── backend.tf                  # Remote backend configuration (S3)
├── main.tf                     # Root module (calls EC2 module)
├── variables.tf                # Root input variables
├── output.tf                   # Root outputs
├── Dev.tfvars                  # Dev environment values
├── Test.tfvars                 # Test environment values
├── terraform.lock.hcl          # Provider lock file
└── README.md                   # Project documentation
```
🧱 Architecture Overview

->Root Module
Acts as the entry point
Calls the reusable EC2 module
Passes environment-specific variables

->EC2 Module
Handles EC2 instance creation
Accepts parameters like instance name, key pair, and public IP configuration
Returns outputs such as private IP

->Remote Backend (S3)
Stores Terraform state securely in an S3 bucket
Enables collaboration and state consistency

->Environment Separation
Uses .tfvars files for Dev and Test environments
Allows same codebase to deploy different configurations
⚙️ Prerequisites

Ensure the following are installed and configured:

Terraform (latest version recommended)
AWS CLI
AWS credentials configured (aws configure)
IAM permissions for:
EC2
S3 (for backend state storage)
🌍 Environments

This project supports multiple environments using .tfvars:

🔹 Dev Environment
Used for development/testing
Public IP disabled
🔹 Test Environment
Used for validation/testing scenarios
Public IP enabled
🚀 How to Use
1. Initialize Terraform

Initialize the working directory and backend:
```text
terraform init
```
2. Select Environment

Use the appropriate .tfvars file depending on your environment:

Dev → Dev.tfvars
Test → Test.tfvars
3. Plan Deployment

Preview infrastructure changes before applying:
```text
terraform plan -var-file="Dev.tfvars"
```
(or use Test.tfvars accordingly)

4. Apply Changes

Provision the infrastructure:
```text
terraform apply -var-file="Dev.tfvars"
```
5. Destroy Resources (Optional)

To clean up resources:
```text
terraform destroy -var-file="Dev.tfvars"
```
📤 Outputs

After deployment, Terraform will display:

Private IP Address of the EC2 instance

This output is useful for:

Internal communication
Backend integrations
Monitoring setups
🔐 Backend State Management
Terraform state is stored remotely in AWS S3
Ensures:
Centralized state management
Collaboration safety
Persistence across runs

📌 Key Concepts Used
Terraform Modules (reusability)
Input Variables (parameterization)
Output Values (resource visibility)
Remote Backend (S3)
Environment-specific configurations (.tfvars)

⚠️ Notes & Best Practices
Do not commit sensitive files (e.g., .tfstate, credentials)
Use .gitignore to exclude unnecessary files
Keep your S3 backend bucket secure
Use consistent naming conventions for environments
Prefer variables over hardcoding values

👨‍💻 **Author**

**Reuben**
**DevOps / Cloud Enthusiast 🚀**