# Terraform Web Infrastructure on AWS

This project builds a layered web infrastructure on AWS using Terraform.  
It features a two-tier Application Load Balancer (ALB → ALB) setup with proxy forwarding in between, along with secure public/private EC2 instances.

![image](https://github.com/user-attachments/assets/bf310091-d87f-49f0-bab5-c0fc016b52ac)




---

## 📌 Architecture Overview

- **VPC** with public and private subnets
- **Internet Gateway** for external access
- **NAT Gateway** to allow private instances outbound internet access (for updates)
- **Public Application Load Balancer (ALB)** receives external traffic
- **Proxy EC2 Instances** (Nginx) in public subnets forward traffic to:
- **Private Application Load Balancer (ALB)** handling internal routing
- **Apache EC2 Instances** in private subnets serve the final content
- **Security Groups** control traffic and ensure isolation
- **Key Pair** generated via Terraform for SSH access
- **S3 Bucket** used for storing backend state (optional)

---

## 🛠️ Tools & Technologies

- Terraform
- AWS (VPC, EC2, ALB, NAT Gateway)
- Amazon Linux 2
- Nginx (Reverse Proxy)
- Apache HTTP Server (Web Hosting)

---

## 🚀 How to Use

1. Clone this repository:

   git clone https://github.com/khkhkhkhader/terraform-web-infra-on-aws.git
   cd terraform-web-infra-on-aws

2. Initialize Terraform
    terraform init

   This command will:
  - Download required providers (AWS, TLS, etc.)
  - Create `.terraform.lock.hcl` to lock provider versions
  - Prepare your environment for planning and deployment
    

3. Set your variables in terraform.tfvars
  (Edit file and provide values like region, key name, etc.)

4. Deploy the infrastructure
  terraform apply

  Approve when prompted (type 'yes')

5. After successful apply, a file will be created:
    
    → all-ips.txt
    
    It will contain public IPs of proxy EC2 instances for any later configuration usage

