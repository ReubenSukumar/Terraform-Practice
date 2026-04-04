**🚀 Terraform AWS Multi-Tier Infrastructure**

This project provisions a production-style multi-tier architecture on AWS using Terraform. It includes networking, compute, load balancing, and database layers designed with high availability and security best practices.

**📌 Architecture Overview**

The infrastructure consists of:

-> Custom VPC  
-> Public, Private, and DB subnets across 2 Availability Zones  
-> Internet Gateway for public access  
-> NAT Instance for private subnet outbound traffic  
-> Public & Private Application Load Balancers (ALB)  
-> Multiple EC2 instances (Web, App, DB layers)  
-> Layered Security Groups  
-> Target Groups & Health Checks  

**🧱 Components**

**🌐 Networking**  
VPC CIDR: 20.0.0.0/16  
Public Subnets:  
20.0.1.0/24 (us-east-1a)  
20.0.2.0/24 (us-east-1b)  
Private Subnets:  
20.0.3.0/24 (us-east-1a)  
20.0.4.0/24 (us-east-1b)  
DB Subnets:  
20.0.5.0/24 (us-east-1a)  
20.0.6.0/24 (us-east-1b)  

**🌍 Internet Access**  
Internet Gateway attached to VPC  
Public Route Table → Internet Gateway  
Private & DB Route Tables → NAT Instance  

**🔐 Security Groups**  
Layer	Description  
Public SG	SSH (restricted), HTTP/HTTPS from Public ALB  
Private SG	SSH from Public instances, App port (3000) from Private ALB  
Public ALB	HTTP/HTTPS from internet  
Private ALB	Traffic from Public instances  
DB SG	MySQL (3306) between DB and App layers  

**🖥️ Compute Layer**  
**Public Instances**  
->2 EC2 instances (Web Layer)  
->Hosted in public subnets  
->Attached to Public ALB  
  
**Private Instances**  
->2 EC2 instances (Application Layer)  
->Hosted in private subnets  
->Connected via Private ALB  
  
**Database Instances**  
Master DB (1a)  
Slave DB (1b)  
Hosted in DB private subnets  
  
**⚖️ Load Balancers**  

**Public ALB**  
Internet-facing    
Routes HTTP (80) traffic to public EC2 instances  

**Private ALB**  
Internal-only  
Routes traffic on port 3000 to private EC2 instances  

**🎯 Target Groups**  
Public ALB Target Group → Port 80  
Private ALB Target Group → Port 3000  
Health Check Path: /health  


**🔑 Key Features**  
✅ Multi-AZ deployment (High Availability)  
✅ Layered architecture (Web → App → DB)  
✅ NAT Instance for private subnet outbound access  
✅ Security Group referencing (zero hardcoding of IPs between layers)  
✅ Health checks for load balancing  
✅ Scalable foundation for Auto Scaling Groups (future enhancement)  

**⚙️ Prerequisites**  
->Terraform installed (>= 1.x)  
->AWS CLI configured  
->Valid AWS credentials  
->Existing Key Pair (Test.pem)  

**🚀 Usage**  
1. Initialize Terraform  
```text
terraform init
```
2. Validate Configuration
```text
terraform validate
```
3. Preview Changes
```text
terraform plan
```
4. Apply Infrastructure
```text
terraform apply
```
5. Destroy Infrastructure
```text
terraform destroy
```  

**⚠️ Important Notes**  
->AMI ID is region-specific (us-east-1)  
->NAT is implemented using a NAT Instance (not NAT Gateway)  
->source_dest_check = false is required for NAT functionality  
->SSH access is restricted to a specific IP (122.171.19.34/32)  
->Health check endpoint /health must be implemented in your app  

  
**📈 Future Improvements**  
->🔄 Replace NAT Instance with NAT Gateway    
->⚡ Add Auto Scaling Groups (ASG)  
->🌍 Integrate with CloudFront + Route 53    
->🔐 Add HTTPS using ACM  
->📊 Add monitoring (Prometheus + Grafana)    

  
**📂 Project Structure**  
.  
├── main.tf        # Complete infrastructure definition  
└── README.md      # Documentation  
  
**NOTE:**  
Update the <MY IP> in Terraform-Public-SG   
Update the pem file name in the EC2 block    

**👨‍💻 Author**

**Reuben**
**DevOps Engineer | AWS | Terraform | Monitoring Enthusiast**