step 1: [vpc service]
--create vpc
--create subnets (us-east-1a(public subnet A , private subnet A, private subnet C), 
                us-east-1b( public subnet B, private subnet B, private subnet D))
--create internet gateway
--create route table
--create route 
i. cloudforce_rt (destination_cidr_block = "0.0.0.0/0")
--associate route table to public subnet (A, B)
--create an elastic IP
--create a NAT gateway in public subnet A & allocate Elastic IP to the NAT Gateway
--create a Route Table for the NAT Gateway ("0.0.0.0/0")
--Associating route table for NAT gateway to (private subnet A & private subnet B)



step 2: [Create a security group for EC2 instances]
--create security group instancesg [allow traffic from port 80, 3000, 22 && allow all outgoing traffic]
--Inbound rule for port 80 (HTTP) (allow)
--Inbound rule for port 3000 (Custom) (allow)
--Inbound rule for port 22 (SSH)
--Outbound rule (Allow all outbound traffic)

step 3: [Create a frontend launchweb template][launchweb.tf ]
--create launch template for frontend include: 
    (image_id, instance_type, security_group[instancesg], 
    associate public_ip, create_before_destroy = true,
    user_data[frontenddata])

step 4: Create user data for front end web

step 5: [Create a launch template for the application server][launchapp.tf ]
--create launch template for application server include: 
    (image_id, instance_type, security_groups[instancesg],
    associate_public_ip_add, create_before_destroy = true,
    user_data[backenddata.sh])

step 6: Create user data for backend end web

step 7: Create an internet facing load balancer [subnets A&B, sg= lbinstancesgB]
--create aws_lb (frontend_lb)
                (load_balancer_type = "application", sg = lbinstancesgB,
                subnets(publicA, publicB))
--create aws_lb_target_group (frontendTG) 
                (port = 80(http), health_checks )
--create aws_lb_listener (frontendListener)
                (port = 80 (http), forwards, tg_arn = frontendTG)

step 8: create a load balancer for our backend service
Here the target groups are the instances on private subnets.
--create aws_lb(backend-lb)
                (load_balancer_type = "application", sg = lbsecuritygroupB,
                subnets(privateA, privateB))
--create aws_lb_target_group (backendTG)
                (port = 80(http), health_checks)
--create aws_lb_listener (backendListener)
                (port = 80 (http), forwards, tg_arn = backendTG)

step 9: create security groups for loadbalancers [open port 80 & 3000 for ingress]
NB: sg = lbinstancesgB (for frontendlb in public subnets A & B)
    sg = lbsecuritygroupB (for backend-lb in private subnets A & B)

step 10: Create an autoscaling group for the frontend service or web servers.
--create aws_autoscaling_group (frontendASG)
        (min_size = 2, max_size = 6, health_check_type = "EC2", 
        publicA & publicB, target_group_arns = aws_lb_target_group.frontendTG.arn)

step 11: 11. Create an autoscaling group for the backend service or application servers.
--create aws_autoscaling_group (backendASG)
        (min_size = 2, max_size = 6, health_check_type = "EC2", 
        privateA & privateB, target_group_arns = aws_lb_target_group.backendTG.arn)

![architecture of diagram](https://github.com/user-attachments/assets/98ea43e6-68d2-4689-9b6f-bd1e1f8d47aa)


https://dev.to/ephantus_gachomba_/-deploying-a-secure-three-tier-aws-architecture-with-terraform-3nfc

