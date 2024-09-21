

![architecture of diagram](https://github.com/user-attachments/assets/98ea43e6-68d2-4689-9b6f-bd1e1f8d47aa)


https://dev.to/ephantus_gachomba_/-deploying-a-secure-three-tier-aws-architecture-with-terraform-3nfc

# Deploying a Secure Three-Tier AWS Architecture with Terraform

## Step 1: VPC Service
- **Create VPC**
- **Create Subnets**:
    - `us-east-1a` (Public Subnet A, Private Subnet A, Private Subnet C)
    - `us-east-1b` (Public Subnet B, Private Subnet B, Private Subnet D)
- **Create Internet Gateway**
- **Create Route Table**
- **Create Route**
    - `cloudforce_rt`: `destination_cidr_block = "0.0.0.0/0"`
- **Associate Route Table to Public Subnets**: (A, B)
- **Create an Elastic IP**
- **Create a NAT Gateway in Public Subnet A and associate Elastic IP to the NAT Gateway**
- **Create a Route Table for NAT Gateway**: `destination_cidr_block = "0.0.0.0/0"`
- **Associate Route Table for NAT Gateway**: (Private Subnet A & Private Subnet B)

---

## Step 2: Create a Security Group for EC2 Instances
- **Create Security Group `instancesg`**: 
    - Allow traffic on port 80 (HTTP), port 3000 (Custom), port 22 (SSH)
    - Allow all outgoing traffic
- **Inbound Rules**:
    - Port 80 (HTTP): Allow
    - Port 3000 (Custom): Allow
    - Port 22 (SSH): Allow
- **Outbound Rules**:
    - Allow all outgoing traffic

---

## Step 3: Create a Frontend Launch Template (`launchweb.tf`)
- **Create Launch Template for Frontend**:
    - `image_id`
    - `instance_type`
    - Security group: `instancesg`
    - Associate public IP
    - `create_before_destroy = true`
    - `user_data`: `frontenddata`

---

## Step 4: Create User Data for Frontend Web
- Include user data script to set up the frontend web server.

---

## Step 5: Create a Launch Template for the Application Server (`launchapp.tf`)
- **Create Launch Template for Application Server**:
    - `image_id`
    - `instance_type`
    - Security group: `instancesg`
    - Associate public IP
    - `create_before_destroy = true`
    - `user_data`: `backenddata.sh`

---

## Step 6: Create User Data for Backend Web
- Include user data script to set up the backend web server.

---

## Step 7: Create an Internet Facing Load Balancer
- **Create Load Balancer for Frontend (`aws_lb.frontend_lb`)**:
    - Load balancer type: `application`
    - Security group: `lbinstancesgB`
    - Subnets: Public Subnets A & B
- **Create Target Group for Frontend (`aws_lb_target_group.frontendTG`)**:
    - Port 80 (HTTP)
    - Health checks
- **Create Listener for Frontend (`aws_lb_listener.frontendListener`)**:
    - Port 80 (HTTP)
    - Forward to target group: `frontendTG`

---

## Step 8: Create a Load Balancer for Backend Service
- **Create Load Balancer for Backend (`aws_lb.backend_lb`)**:
    - Load balancer type: `application`
    - Security group: `lbsecuritygroupB`
    - Subnets: Private Subnets A & B
- **Create Target Group for Backend (`aws_lb_target_group.backendTG`)**:
    - Port 80 (HTTP)
    - Health checks
- **Create Listener for Backend (`aws_lb_listener.backendListener`)**:
    - Port 80 (HTTP)
    - Forward to target group: `backendTG`

---

## Step 9: Create Security Groups for Load Balancers
- **Security Group for Frontend Load Balancer** (`lbinstancesgB`):
    - Open ports 80 & 3000 for ingress
- **Security Group for Backend Load Balancer** (`lbsecuritygroupB`):
    - Open port 80 for ingress
    - Open port 3000 for ingress

---

## Step 10: Create an Auto Scaling Group for Frontend Service
- **Create Auto Scaling Group for Frontend (`aws_autoscaling_group.frontendASG`)**:
    - Min size: `2`
    - Max size: `6`
    - Health check type: `EC2`
    - Public subnets: A & B
    - Target group ARNs: `aws_lb_target_group.frontendTG.arn`

---

## Step 11: Create an Auto Scaling Group for Backend Service
- **Create Auto Scaling Group for Backend (`aws_autoscaling_group.backendASG`)**:
    - Min size: `2`
    - Max size: `6`
    - Health check type: `EC2`
    - Private subnets: A & B
    - Target group ARNs: `aws_lb_target_group.backendTG.arn`

## Step 12: Create s3 bucket & cloudtrails
- **create aws_s3_bucket (cloudfront_trail_bucket)**
--data "aws_iam_policy_document" "cloudfront_trail_policy"
--"aws_cloudtrail" "cloudfront_trail"

