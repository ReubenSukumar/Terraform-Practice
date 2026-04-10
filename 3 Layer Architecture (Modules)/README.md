🚀 3-Tier Architecture on AWS using Terraform  

This project provisions a complete 3-tier architecture on AWS using Terraform, following best practices for modular infrastructure, scalability, and automation.

📌 Architecture Overview  

This setup includes:
```text
VPC with public & private subnets
Public Layer (Frontend) → NGINX + NAT Instance
Private Layer (Backend) → Application instances
Database Layer → MySQL Master-Slave (GTID replication)
Load Balancers
Public ALB → Frontend
Private ALB → Backend
Security Groups → Controlled access between layers
```
🏗️ Project Structure
```text
3 Layer Architecture (Modules)
│
├── Module_VPC
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│ 
├── Module_EC2
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│ 
├── Module_ALB_and_TG
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│ 
├── Module_Security_Group
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── Scripts
│   ├── mysql_master.sh.tpl
│   ├── mysql_slave.sh.tpl
│   └── nginx_and_nat.sh.tpl
│
├── main.tf
└── outputs.tf
```

⚙️ Modules Description

🔹 VPC Module  
Creates VPC, subnets (public, private, DB)  
Internet Gateway + Route Tables  
NAT routing via public instance  
👉 Example CIDR: 20.0.0.0/16

🔹 EC2 Module  
Public Instances (NGINX + NAT)  
Private Instances (Backend)  
DB Instances (MySQL Master-Slave)  

Includes:  

NAT setup + NGINX reverse proxy  
MySQL GTID replication (automated)  

🔹 ALB & Target Groups Module  
Public ALB → Routes traffic to frontend (port 80)   
Private ALB → Routes traffic to backend (port 3000)   
Health checks on /health endpoint  


🔹 Security Group Module   
Fine-grained access control between:  
Public ↔ Private  
Private ↔ DB  
ALB ↔ Instances  
Restricts SSH access to your IP    
🔁 Traffic Flow  
```text
User → Public ALB → NGINX (Public EC2)  
     → Private ALB → Backend EC2  
     → MySQL Master → MySQL Slave 
```      

🧠 Key Features  
```text
✅ Modular Terraform design
✅ Highly available (Multi-AZ deployment)
✅ NAT Instance for private subnet internet access
✅ Internal & External Load Balancers
✅ Automated MySQL GTID replication
✅ NGINX reverse proxy with API routing
✅ Health checks for resilience
```

🔧 Prerequisites  
AWS Account  
Terraform installed  
SSH key pair (.pem)  
IAM permissions for:  
EC2  
VPC  
ALB  
Security Groups


🚀 How to Deploy  
1. Initialize Terraform
```text
terraform init
```
2. Validate Configuration  
```text
terraform validate
```
3. Plan Deployment   
```text
terraform plan
```
4. Apply Infrastructure  
```text
terraform apply
```
📤 Outputs  

After deployment, Terraform provides:  

Public Instance IPs  
Private Instance IPs  
ALB Names & DNS  
Instance Names  
🌐 Application Access  
Access via Public ALB DNS  

NGINX serves:  
/ → Static frontend  
/api/ → Backend (via Private ALB)  

🛢️ Database Setup  
Master DB  
GTID enabled  
Binary logging enabled  

Slave DB  
Auto replication using MASTER_AUTO_POSITION=1  

Replication user:  
```text
CREATE USER 'repli'@'20.0.6%' IDENTIFIED BY 'password';
```

🔐 Security Highlights  
No public access to backend or DB  
DB accessible only from private instances  
ALB-based routing ensures isolation  
SSH restricted to specific IP  


⚠️ Notes  
Uses NAT Instance instead of NAT Gateway (cost optimization)  
AMI is region-specific (us-east-1)  
->Update:  
SSH IP  
Key pair name  
Passwords (for production) 


📌 Future Improvements  
Auto Scaling Groups (ASG)  
CloudFront integration  
CI/CD pipeline  
Monitoring (Prometheus + Grafana)  
HTTPS with ACM  


**👨‍💻 Author**  

**Reuben Sukumar R**  
**Cloud / DevOps Engineer**   