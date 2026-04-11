**🚀 3-Tier Architecture on AWS using Terraform (HTTPS + Route53 + ACM)**  

This project provisions a production-style 3-tier architecture on AWS using Terraform, enhanced with custom domain, HTTPS (ACM), and Route 53 DNS integration.  

**📌 Architecture Overview**  

This setup includes:  
```text
VPC with public, private, and DB subnets
Public Layer → NGINX + NAT Instance
Private Layer → Backend (App instances)
Database Layer → MySQL Master-Slave (GTID replication)

Load Balancers
Public ALB (HTTPS enabled via ACM)
Private ALB (internal routing)

DNS & SSL
Route 53 hosted zone
ACM certificate with DNS validation

Security Groups → Layered access control
```  
**🏗️ Project Structure**  
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
├── Module_R53_ACM
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
│
├── Scripts
│   ├── mysql_master.sh.tpl
│   ├── mysql_slave.sh.tpl
│   └── nginx_and_nat.sh.tpl
│
├── main.tf
└── outputs.tf
```  
**⚙️ Modules Description**  

**🔹 VPC Module**  
▪ Creates VPC, subnets (Public, Private, DB)  
▪ Internet Gateway + Route Tables  
▪ NAT routing via public EC2 instance  
▪ Example CIDR: 20.0.0.0/16  


**🔹 EC2 Module**  
▪ Public Instances → NGINX + NAT  
▪ Private Instances → Backend  
▪ DB Instances → MySQL Master-Slave  
  
Includes:  
  
▪ NAT configuration + IP forwarding  
▪ NGINX reverse proxy  
▪ Automated MySQL GTID replication    


**🔹 ALB & Target Groups Module**  
▪ Public ALB → HTTPS (443) with ACM certificate  
▪ HTTP (80) → Redirect to HTTPS  
▪ Private ALB → Backend routing (port 3000)  
▪ Health checks on /health  
  
Implements:  
  
▪ HTTPS listener with certificate  
▪ Internal load balancing between backend instances    
  
  
**🔹 Security Group Module**  
▪ Restricts traffic between layers:  
```text
Public ↔ Private
Private ↔ DB
ALB ↔ Instances
```  
▪ SSH restricted to your IP  
▪ DB access only from private instances  

  
**🔹 Route 53 + ACM Module**  
▪ Creates hosted zone for domain  
▪ Issues SSL certificate (DNS validation)  
▪ Automatically validates ACM using Route 53  
▪ Maps domain → Public ALB (Alias record)  
**🔁 Traffic Flow**  
```text
User → Domain (Route53)
     → Public ALB (HTTPS)
     → NGINX (Public EC2)
     → Private ALB
     → Backend EC2
     → MySQL Master → MySQL Slave  
```  
  
**🧠 Key Features**  
```text 
✅ Modular Terraform architecture
✅ HTTPS enabled using ACM
✅ Custom domain via Route 53
✅ DNS-based certificate validation (fully automated)
✅ Multi-AZ deployment
✅ NAT Instance (cost optimization)
✅ Internal & External ALBs
✅ MySQL GTID replication (auto-configured)
✅ NGINX reverse proxy with API routing
✅ Health checks for resilience
```  
  
**🔧 Prerequisites**  
▪ AWS Account  
▪ Terraform installed  
▪ SSH key pair (.pem)  
▪ IAM permissions for:
```text  
   ▪ EC2  
   ▪ VPC  
   ▪ ALB  
   ▪ Route 53  
   ▪ ACM
```     
  
**🚀 How to Deploy**  
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
  
**🌐 Application Access**  
  
After deployment:  
  
▪ Access your app using your custom domain 
▪ Example:  
```text
https://johnwick.lol
```
  
Routing:  
```text
/       → Static frontend (NGINX)
/api/   → Backend via Private ALB
```
  
NGINX proxies requests internally to backend using ALB DNS  
  
**📤 Outputs**  
  
Terraform provides:  
  
▪ Public Instance IPs  
▪ Private Instance IPs  
▪ ALB Names & DNS  
▪ Domain Name  
▪ ACM Certificate ARN  
  
**🛢️ Database Setup**  
    
Master DB  
▪ GTID enabled  
▪ Binary logging enabled  
▪ Replication user auto-created  
  
Slave DB   
▪ Auto replication using:
```text
MASTER_AUTO_POSITION = 1
```
▪ Dynamically connects using master private IP  
  
**🔐 Security Highlights**  
```text
No public access to backend or DB  
DB only accessible from private instances  
HTTPS enforced (HTTP → HTTPS redirect)  
Layered security groups for isolation  
SSH restricted to your IP  
```
  
**⚠️ Notes**  
```text
Uses NAT Instance instead of NAT Gateway (cost optimization)
ACM validation may take a few minutes
AMI is region-specific (us-east-1)
Update before deployment:
  - Domain name
  - SSH IP
  - Key pair name
  - DB passwords
```  
  
**📌 Future Improvements**  
Auto Scaling Groups (ASG)  
CloudFront CDN integration  
CI/CD pipeline (Jenkins/GitHub Actions)  
Monitoring (Prometheus + Grafana)  
WAF (Web Application Firewall)  
Secrets Manager for DB credentials 

**👨‍💻 Author**    
  
**Reuben Sukumar R**  
**Cloud / DevOps Engineer**  