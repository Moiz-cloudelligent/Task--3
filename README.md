# Cloudelligent AWS Infrastructure Project

A complete three-tier application infrastructure on AWS using Terraform as Infrastructure as Code (IaC). This production-ready project demonstrates enterprise-level AWS architecture with modular Terraform structure and remote state management.

## 🎯 What This Project Does

This project automatically creates and configures a complete three-tier AWS infrastructure:

**Tier 1 - Presentation Layer (Load Balancing)**
- Application Load Balancer (ALB) for distributing traffic
- Security groups for HTTP/HTTPS traffic

**Tier 2 - Application Layer (Compute)**
- EC2 instances running Apache web server
- Auto-scaling ready infrastructure
- Private subnet deployment for security

**Tier 3 - Data Layer (Database)**
- RDS MySQL database
- Encrypted storage
- Backup retention
- Private subnet placement

**Networking Foundation**
- Custom VPC with CIDR block `10.0.0.0/16`
- 2 Public subnets for load balancer
- 2 Private subnets for application and database tiers
- Internet Gateway for public internet access
- NAT Gateway for private subnet outbound connectivity
- Security groups with least-privilege access

## � State Management

This project uses **AWS S3 backend** for remote state management, enabling team collaboration and state locking.

### Initial Setup: Create S3 Backend (One-time)

Before applying infrastructure, create the S3 bucket and DynamoDB table for state management:

```powershell
# Create S3 bucket for Terraform state
aws s3api create-bucket --bucket cloudelligent-terraform-state --region us-east-1

# Enable versioning on S3 bucket
aws s3api put-bucket-versioning `
  --bucket cloudelligent-terraform-state `
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table `
  --table-name terraform-locks `
  --attribute-definitions AttributeName=LockID,AttributeType=S `
  --key-schema AttributeName=LockID,KeyType=HASH `
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 `
  --region us-east-1
```

### Migrate State to S3

```powershell
# Initialize with S3 backend
terraform init

# When prompted, confirm the migration
```

This configuration is already in `backend.tf`:
```terraform
terraform {
  backend "s3" {
    bucket         = "cloudelligent-terraform-state"
    key            = "task3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

**Benefits:**
- ✅ State stored securely in S3 with encryption
- ✅ State locking with DynamoDB prevents concurrent modifications
- ✅ Team collaboration with centralized state
- ✅ Version history of infrastructure changes

---

Before you begin, make sure you have:

1. **AWS Account** - You need an active AWS account
2. **AWS Credentials** - Configure your AWS access keys on your computer
3. **Terraform Installed** - Download from [terraform.io](https://www.terraform.io/downloads.html)
4. **Basic Command Line Knowledge** - Ability to open and use PowerShell or Command Prompt

### Setup AWS Credentials (Windows)

1. Create AWS Access Key ID and Secret Access Key from AWS Console
2. Open PowerShell and run:
```powershell
aws configure
```
3. Enter your Access Key ID and Secret Access Key when prompted
4. Set default region to: `us-east-1`

##  Project Structure

```
Task 3/
├── main.tf                      # Root configuration file
├── variables.tf                 # Root variable definitions
├── outputs.tf                   # Root outputs (3-tier resources)
├── backend.tf                   # Remote S3 backend configuration
├── terraform.tfstate            # Local state (before S3 migration)
└── modules/
    ├── networking/              # VPC, subnets, gateways, route tables
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── compute/                 # EC2 instances, security groups
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── user_data.sh
    ├── load_balancer/           # ALB, target groups, listeners
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── database/                # RDS MySQL, DB subnet group
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## 🏗️ Architecture Overview

```
Internet
    ↓
[Internet Gateway]
    ↓
[ALB] (Public Subnet)
    ↓
[EC2 Web Servers] (Private Subnets) ←→ [RDS MySQL] (Private Subnets)
    ↓
[NAT Gateway] (Public Subnet) → Internet (for updates)
```
    │   ├── variables.tf
    │   └── outputs.tf
    └── compute/                 # EC2 instances
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── user_data.sh         # Script to install web server
```

##  Quick Start

### Step 1: Navigate to Project Directory

Open PowerShell and go to the project folder:

```powershell
cd "C:\Users\Abdul Moiz Bin Tahir\Desktop\Cloudelligent\Tasks\Task 3"
```

### Step 2: Initialize Terraform

This downloads required providers and modules:

```powershell
terraform init
```

**Expected Output:** You should see "Terraform has been successfully initialized!"

### Step 3: Preview Changes

See what infrastructure will be created:

```powershell
terraform plan
```

**Expected Output:** Shows "Plan: X to add, 0 to change, 0 to destroy"

### Step 4: Create Infrastructure

Deploy the infrastructure to AWS:

```powershell
terraform apply
```

When prompted, type `yes` and press Enter. **This will take 3-5 minutes.**

**Expected Output:** "Apply complete! Resources: X added"

### Step 5: Access Your Application

Get the load balancer DNS name:

```powershell
terraform output
```

Look for `load_balancer_dns_name`. Copy the value (looks like: `moiz-alb-123456789.us-east-1.elb.amazonaws.com`)

Open your web browser and paste the DNS name. You should see:

```
Welcome to Cloudelligent
This is Instance #1 (or #2)
Hostname: [server hostname]
Instance ID: i-xxxxxxxxx
```

Refresh the page several times - you'll see traffic balanced between Instance #1 and Instance #2!

## 📊 What Gets Created

| Resource | Purpose | Count | Tier |
|----------|---------|-------|------|
| VPC | Virtual Private Cloud | 1 | Network |
| Public Subnets | Internet-facing subnets | 2 | Network |
| Private Subnets | Backend subnets (no internet) | 2 | Network |
| Internet Gateway | Allows public internet access | 1 | Network |
| NAT Gateway | Private subnet outbound access | 1 | Network |
| Load Balancer | Distributes traffic | 1 | Tier 1 |
| EC2 Instances | Web servers | 2 | Tier 2 |
| RDS MySQL | Relational database | 1 | Tier 3 |
| Security Groups | Network firewalls | 3 | Network |
| **Total Resources** | | **14** | |

## 🔧 Project Configuration

### Network Setup
- **VPC CIDR Block:** `10.0.0.0/16`
- **Public Subnets:** `10.0.0.0/24`, `10.0.1.0/24`
- **Private Subnets:** `10.0.2.0/24`, `10.0.3.0/24`

### Compute Setup (Tier 2)
- **Instance Type:** t2.micro (free tier eligible)
- **Instance Count:** 2
- **AMI:** Latest Amazon Linux 2
- **Web Server:** Apache HTTP Server
- **Placement:** Private subnets
- **Access:** Through ALB only

### Database Setup (Tier 3)
- **Engine:** MySQL 8.0
- **Instance Class:** db.t3.micro
- **Storage:** 20GB encrypted
- **Backup Retention:** 7 days
- **Multi-AZ:** Disabled (single-AZ for cost)
- **Placement:** Private subnets
- **Access:** From EC2 instances only (port 3306)

### Resource Naming
All resources are prefixed with `moiz` for easy identification in AWS Console.

## 🗑️ Cleanup (Delete All Resources)

To remove all created resources and stop incurring charges:

```powershell
terraform destroy
```

When prompted, type `yes` and press Enter.

**Warning:** This will delete all infrastructure. Make sure you don't have important data before doing this.

## 📊 Useful Commands

```powershell
# View all outputs
terraform output

# View specific output
terraform output load_balancer_dns_name

# View infrastructure state
terraform state list

# Refresh state without making changes
terraform refresh

# See detailed plan
terraform plan -out=tfplan

# Check syntax errors
terraform validate
```


## 💡 Next Steps

After getting this working, try:
1. **Enable Multi-AZ** - Change database to `multi_az = true` for high availability
2. **Add HTTPS** - Create ACM certificate and HTTPS listener
3. **Add Auto Scaling** - Implement ASG with launch templates
4. **Database Replication** - Add read replicas for scaling
5. **CloudWatch Monitoring** - Add alarms for CPU, memory, database performance
6. **WAF (Web Application Firewall)** - Protect ALB from attacks
7. **Route 53** - Add custom domain name routing
8. **Secrets Manager** - Store RDS password securely instead of in state

## 🏆 Best Practices Demonstrated

✅ **Modular Structure** - Separated into networking, compute, load balancer, and database modules  
✅ **Remote State Management** - S3 backend with encryption and DynamoDB locking  
✅ **Security** - Private subnets, security groups with least privilege, encrypted storage  
✅ **Availability** - Multi-AZ subnets, load balancing across instances  
✅ **IaC Principles** - Infrastructure defined as code, version controlled, reproducible  
✅ **Scalability** - Easy to add more instances or modify configuration  
✅ **Documentation** - Comments in code, comprehensive README  

## 📚 Understanding Three-Tier Architecture

**Why three tiers?**
- **Separation of Concerns** - Each layer has a specific responsibility
- **Scalability** - Each tier can be scaled independently
- **Security** - Database never exposed to internet, application tier accessed only through load balancer
- **Maintenance** - Changes to one tier don't affect others
- **Reliability** - If one tier fails, others can continue operating

## ❓ FAQ

**Q: How much will this cost?**
A: The t2.micro instances qualify for AWS free tier if you have an active account. However, NAT Gateway charges ~$32/month, and data transfer has costs.

**Q: Can I modify instance count?**
A: Yes! Edit `modules/compute/variables.tf` and change `instance_count = 2` to any number you want.

**Q: How do I update the web page?**
A: Edit `modules/compute/user_data.sh` and run `terraform apply` to redeploy instances.

**Q: Why use modules?**
A: Modules organize code into reusable pieces, making it easier to manage and scale projects.

## 📞 Support

For issues or questions:
1. Check Terraform logs: Review the apply/plan output
2. Check AWS Console: Verify resources were created correctly
3. Review security groups: Ensure proper traffic rules

---

**Created by:** Cloudelligent  
**Date:** March 2026  
**Status:** Production Ready ✅
