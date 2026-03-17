🚀 Terraform AWS EC2 Deployment

This project provisions an AWS EC2 instance using Terraform in the us-east-1 region. It is designed as a simple, beginner-friendly setup for infrastructure automation.


📌 Overview

This Terraform configuration will:
Configure AWS provider
Launch an EC2 instance
Attach it to an existing Security Group
Place it inside a specific Subnet
Assign a public IP address

Tag the instance for identification


🧱 Architecture

```text
Terraform → AWS Provider → EC2 Instance
                         ├── Subnet
                         ├── Security Group
                         ├── Key Pair
                         └── Public IP
```



⚙️ Prerequisites

Before running this project, ensure you have:

✅ AWS Account
✅ IAM User with programmatic access
✅ AWS CLI configured

aws configure

✅ Terraform installed

terraform -v

✅ Existing resources:

Security Group (sg-xxxxxxxx)

Subnet (subnet-xxxxxxxx)

Key Pair (.pem file)

📁 Project Structure

```text
.
├── main.tf          # Terraform configuration file
└── README.md        # Project documentation
```

🔧 Configuration Details
Provider
provider "aws" {
  region = "us-east-1"
}


EC2 Instance
resource "aws_instance" "Trial-Instance" {

```text
Parameter	                            Description
ami	                            AMI ID (Free tier eligible recommended)
instance_type	                Instance size (t3.micro free tier eligible)
security_groups	                Existing security group
subnet_id	                    Subnet for deployment
key_name	                    SSH key pair name
associate_public_ip_address	    Enables public IP
tags	                        Instance name
```


🚀 Deployment Steps

```text
1️⃣ Initialize Terraform
terraform init
2️⃣ Validate Configuration
terraform validate
3️⃣ Preview Changes
terraform plan
4️⃣ Apply Configuration
terraform apply
```

Type yes when prompted.


🌐 Access EC2 Instance

Once deployed: Get Public IP from AWS Console


Connect using SSH: ssh -i Test.pem ubuntu@<PUBLIC_IP>
🧹 Destroy Resources


To avoid AWS charges:
terraform destroy
⚠️ Important Notes

Ensure AMI is valid for your region (us-east-1)

Security group must allow: SSH (port 22)

Key pair must exist in AWS

**Avoid hardcoding IDs in production (use variables instead)**