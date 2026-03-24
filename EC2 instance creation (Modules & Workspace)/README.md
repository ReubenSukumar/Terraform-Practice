🚀 Terraform EC2 Deployment using Modules & Workspaces

This project demonstrates how to provision an AWS EC2 instance using Terraform Modules, while supporting multiple environments through variable files and maintaining state using a remote S3 backend.

It follows industry best practices such as modular design, reusable components, and environment-based configuration.

📁 Project Structure
```text
EC2 instance creation (Modules & Workspace)/
│
├── EC2_Module/              # Reusable EC2 module
│   ├── main.tf
│   ├── variables.tf
│   └── output.tf
│
├── terraform/               # Terraform internal directory (auto-generated)
├── backend.tf               # Remote backend configuration
├── main.tf                  # Root module (invokes EC2 module)
├── variables.tf             # Root variables
├── outputs.tf               # Root outputs
├── Dev.tfvars               # Development environment variables
├── Test.tfvars              # Testing environment variables
├── terraform.lock.hcl       # Provider lock file
└── README.md                # Project documentation
```
🧱 Architecture Overview
Root Module
Serves as the entry point of the project
Calls the reusable EC2 module
Passes environment-specific values
EC2 Module
Responsible for provisioning EC2 instances
Accepts configurable inputs such as instance name, key pair, and network settings
Outputs useful information like private IP address
Remote Backend (S3)
Stores Terraform state in an S3 bucket
Ensures state consistency and enables collaboration
🌍 Environment Configuration

This project supports multiple environments using .tfvars files:

🔹 Dev Environment
Used for development and experimentation
Typically minimal or restricted configuration
🔹 Test Environment
Used for validation and testing
Can differ in naming or exposure settings

Each environment uses the same infrastructure code but different variable values.

⚙️ Prerequisites

Make sure the following are set up:

Terraform installed
AWS CLI configured
Valid AWS credentials with permissions for:
EC2
S3 (for backend storage)
🚀 Usage Instructions
1. Initialize Terraform

Initialize the working directory and backend configuration.

2. Choose Environment

Select the appropriate environment file:

Dev.tfvars for development
Test.tfvars for testing
3. Plan Deployment

Preview the infrastructure changes before applying them.

4. Apply Changes

Deploy the EC2 instance based on the selected environment.

5. Destroy Resources (Optional)

Clean up infrastructure when no longer needed.

📤 Outputs

After successful deployment, the following information is available:

Private IP Address of the EC2 instance

This is useful for internal communication, monitoring, or backend integration.

🔐 Remote State Management
Terraform state is stored in an S3 bucket
Provides:
Centralized state storage
Safer collaboration
Persistence across runs
📌 Key Concepts Used
Terraform Modules (code reusability)
Input Variables (flexibility)
Output Values (resource visibility)
Remote Backend (S3)
Environment separation using .tfvars
⚠️ Best Practices
Avoid committing sensitive files such as state files or credentials
Use .gitignore to exclude unnecessary files
Keep backend storage secure
Use meaningful naming conventions for resources and environments
Prefer variables instead of hardcoding values
🧠 Learning Outcomes

This project helps you understand:

Structuring Terraform projects professionally
Creating reusable infrastructure using modules
Managing multiple environments efficiently
Implementing remote state management