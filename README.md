# TASK 3 - Beginner's Guide

A complete beginner-friendly guide to building a three-tier web application infrastructure on AWS using Terraform. This project demonstrates how to create a production-ready cloud infrastructure with automatic deployment.

## What This Project Does

This project automatically creates and deploys a complete three-tier cloud infrastructure on AWS. Think of it like building a restaurant with three separate departments:

**Tier 1 - Front Door (Load Balancing)**
- Application Load Balancer that receives all customer requests
- Distributes traffic fairly across multiple servers
- Acts like a receptionist directing customers

**Tier 2 - Kitchen (Application Servers)**
- 2 EC2 instances (virtual servers) running Apache web server
- Each server can process customer requests
- Located in private networks (hidden from direct internet access)
- Can scale automatically if needed

**Tier 3 - Storage Room (Database)**
- RDS MySQL database for storing application data
- Encrypted storage for security
- Automatic backups every 7 days
- Located in private networks (only accessible from app servers)

**Networking Foundation**
- Custom Virtual Private Cloud (VPC) - Your own private network in AWS
- 2 Public subnets - Where the Load Balancer sits (can access internet)
- 2 Private subnets - Where servers and database sit (protected from internet)
- Internet Gateway - The door to the public internet
- NAT Gateway - Secret exit for private servers to download updates
- Security Groups - Firewalls controlling who can talk to whom

## Prerequisites: What You Need

Before starting, make sure you have:

1. AWS Account - Create at https://aws.amazon.com if you don't have one
2. Terraform Installed - Download from https://www.terraform.io/downloads.html
3. AWS CLI Installed - Download from https://aws.amazon.com/cli/
4. Text Editor - VS Code, Notepad++, or any code editor
5. Command Line Access - PowerShell or Command Prompt on Windows
6. Basic Command Line Knowledge - Ability to navigate folders and run commands

## Step 1: Configure AWS Credentials

Your local computer needs permission to access your AWS account.

1. Go to AWS Console: https://console.aws.amazon.com
2. Click your username (top right) > Security Credentials
3. Click "Access Keys" > "Create New Access Key"
4. Download the CSV file and save it somewhere safe
5. Open PowerShell and run:

```powershell
aws configure
```

6. When prompted, enter:
   - AWS Access Key ID: [from your CSV file]
   - AWS Secret Access Key: [from your CSV file]
   - Default region: us-east-1
   - Default output format: json

Now AWS CLI knows who you are!

## Step 2: Download or Clone This Project

Option A - Download the ZIP file:
1. Go to the GitHub repository
2. Click "Code" > "Download ZIP"
3. Extract the ZIP file to your computer
4. Open PowerShell and navigate to the folder

Option B - Use Git:
```powershell
git clone https://github.com/AbMoiz1/Task--3.git
cd Task--3
```

## Step 3: Initialize Terraform

This step downloads the necessary AWS plugins and prepares your project.

```powershell
terraform init
```

You should see: "Terraform has been successfully initialized!"

## Step 4: Review What Will Be Created

Before creating anything, let's see what Terraform plans to build:

```powershell
terraform plan
```

This shows:
- 20+ AWS resources that will be created
- Load Balancer details
- EC2 instances configuration
- Database settings
- Network setup

Review this carefully to understand what's being created.

## Step 5: Create the Infrastructure

This step actually creates everything in your AWS account. This typically takes 10-15 minutes.

```powershell
terraform apply
```

When prompted, type "yes" and press Enter.

Wait for completion. You'll see:
```
Apply complete! Resources: 20 added, 0 changed, 0 destroyed.
```

## Step 6: Access Your Application

After deployment, get your Load Balancer's web address:

```powershell
terraform output load_balancer_dns_name
```

You'll see something like:
```
moiz-alb-565298247.us-east-1.elb.amazonaws.com
```

Open this address in your browser to see your application running!

## Project Structure Explained

```
Task-3/
├── README.md                    <- This file
├── main.tf                      <- Root configuration (combines all modules)
├── variables.tf                 <- Input variables for the root
├── outputs.tf                   <- Outputs shown after deployment
├── backend.tf                   <- Configuration for storing state
├── terraform.tfstate            <- Current state of infrastructure (created after apply)
│
└── modules/                     <- Reusable building blocks
    │
    ├── networking/              <- Network configuration
    │   ├── main.tf              <- VPC, subnets, gateways
    │   ├── variables.tf         <- Network inputs
    │   └── outputs.tf           <- Network outputs
    │
    ├── compute/                 <- Web server configuration
    │   ├── main.tf              <- EC2 instances
    │   ├── variables.tf         <- Compute inputs
    │   ├── outputs.tf           <- Compute outputs
    │   └── user_data.sh         <- Script to install Apache
    │
    ├── load_balancer/           <- Load balancer configuration
    │   ├── main.tf              <- ALB setup
    │   ├── variables.tf         <- Load balancer inputs
    │   └── outputs.tf           <- Load balancer outputs
    │
    └── database/                <- Database configuration
        ├── main.tf              <- RDS MySQL setup
        ├── variables.tf         <- Database inputs
        └── outputs.tf           <- Database outputs
```

## Understanding Each Module

### Networking Module

Creates the foundation of your infrastructure:
- VPC (Virtual Private Cloud) - Your private network in AWS
- Public Subnets - Accessible from internet (for Load Balancer)
- Private Subnets - Not accessible from internet (for servers and database)
- Internet Gateway - Connection to the public internet
- NAT Gateway - Allows private servers to reach internet

### Compute Module

Creates the application servers:
- 2 EC2 instances (t2.micro - free tier eligible)
- Amazon Linux 2 operating system
- Apache web server pre-installed
- Auto-discovery of latest AMI (image)
- Security group allowing traffic only from Load Balancer

### Load Balancer Module

Creates traffic distribution:
- Application Load Balancer (ALB)
- Target Group (tracks healthy instances)
- Listener (listens on port 80)
- Security group allowing HTTP traffic

### Database Module

Creates the data storage:
- RDS MySQL instance
- 20GB encrypted storage
- 7-day backup retention
- DB Subnet Group for private placement
- Security group allowing only application servers to connect

## Key Concepts Explained

### VPC (Virtual Private Cloud)
Think of it as your own private data center in AWS. It's completely isolated from other customers' resources.

### Subnets
Divisions within your VPC. Public subnets can be accessed from the internet. Private subnets cannot.

### Security Groups
Firewalls that control traffic. They define what can enter and exit each resource.

### Load Balancer
Distributes incoming traffic across multiple servers. If one server fails, others handle the load.

### EC2 Instances
Virtual servers. They run your application code and serve web pages.

### RDS Database
Managed database service. AWS handles backups, updates, and maintenance.

### Terraform State
A file that tracks what infrastructure you've created. It's like a record of everything Terraform has built.

## Useful Commands

### View Infrastructure Details
```powershell
terraform output
```
Shows all important details: Load Balancer DNS, Database endpoint, etc.

### Check Current State
```powershell
terraform state list
```
Lists all created resources.

### Make Changes
Edit variables in main.tf, then:
```powershell
terraform plan      # Preview changes
terraform apply     # Apply changes
```

### Destroy Everything
When you're done, delete all resources to stop incurring charges:
```powershell
terraform destroy
```
Type "yes" when prompted.

## Accessing the Database

The database is not directly accessible from the internet (for security). Only the EC2 instances can connect to it.

Database Details:
- Endpoint: Available in 'terraform output database_endpoint'
- Port: 3306 (MySQL standard)
- Username: admin
- Password: Auto-generated and stored in Terraform state

To connect from EC2 instance:
```bash
mysql -h <database-endpoint> -u admin -p
```

## Security Features Implemented

1. Network Isolation - Database and servers are in private subnets
2. Access Control - Security groups restrict traffic
3. Encryption - Database storage is encrypted
4. Least Privilege - Each component has minimum required permissions
5. Backups - Database backs up daily for 7 days

## Cost Considerations

This infrastructure costs money to run:
- Load Balancer: about $16/month
- 2 EC2 t2.micro instances: Free tier eligible
- NAT Gateway: about $32/month
- RDS MySQL t3.micro: about $20/month
- Data transfer: Variable

Total: about $40-50/month if running 24/7

To avoid charges:
- Run 'terraform destroy' when not using
- Or use AWS Free Tier (limited to 12 months)

## Troubleshooting

### Error: Module not installed
Solution: Run 'terraform init'

### Error: Access Denied
Solution: Check AWS credentials with 'aws configure'

### Load Balancer DNS not responding
Solution: Wait 5 minutes for instances to fully boot and connect

### Database not available
Solution: Wait 3-5 minutes for RDS to finish creating

### Permission denied when pushing to GitHub
Solution: Use your own repository or ask for contributor access

## What Happens When You Deploy

1. Terraform reads all .tf files
2. Creates a plan of what will be built
3. Connects to your AWS account using credentials
4. Creates VPC and subnets
5. Creates Internet Gateway and NAT Gateway
6. Creates Load Balancer
7. Creates EC2 instances (takes 2-3 minutes)
8. Installs Apache web server on instances
9. Creates RDS database (takes 5+ minutes)
10. Connects everything together
11. Saves infrastructure details in terraform.tfstate

## Learning Resources

- Terraform Documentation: https://www.terraform.io/docs
- AWS Documentation: https://docs.aws.amazon.com/
- AWS Terraform Provider: https://registry.terraform.io/providers/hashicorp/aws/latest
- Terraform Best Practices: https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices

## Next Steps After Deployment

Now that you have basic infrastructure:

1. Connect Application - Deploy your web app to EC2 instances
2. Configure Database - Create tables and load data
3. Set Up Monitoring - Add CloudWatch alerts
4. Enable HTTPS - Add SSL certificate for security
5. Scale Up - Add more instances or database replicas
6. Automate - Set up CI/CD pipelines for deployments

## Common Questions

Q: Can I modify the number of EC2 instances?
A: Yes! Edit modules/compute/variables.tf and change instance_count

Q: How do I add HTTPS/SSL?
A: Create an ACM certificate and add HTTPS listener to ALB

Q: Can I resize the database?
A: Yes, modify instance_class in modules/database/variables.tf

Q: How long does deployment take?
A: Typically 10-15 minutes (mostly waiting for RDS)

Q: Can multiple people use this project?
A: Yes, set up S3 remote backend for shared state management

## File Descriptions

- main.tf - Links all modules together, defines provider
- variables.tf - Defines input variables for root module
- outputs.tf - Defines what information is shown after apply
- backend.tf - Configures where Terraform state is stored
- modules/[*/main.tf - Actual resource definitions for each component
- modules/[*/variables.tf - Input variables for each module
- modules/[*/outputs.tf - Output values from each module



## Project Details

Created: March 2026
Status: Production Ready
Total Resources: 20+
Infrastructure Tiers: 3 (Load Balancing, Application, Database)


