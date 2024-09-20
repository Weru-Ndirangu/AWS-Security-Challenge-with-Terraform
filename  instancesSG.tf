#allow traffic from port 80, 3000, 22
#allow all outgoing traffic
resource "aws_security_group" "instancesg" {
  name        = "instancesg"
  description = "allow traffic from port 80, 3000, 22 & allow all outgoing traffic"
  vpc_id      = aws_vpc.cloudforce_vpc.id

  tags = {
    Name = "instancesg"
  }
}

# Inbound rule for port 80 (HTTP)
resource "aws_vpc_security_group_ingress_rule" "allow_tcp_80" {
  security_group_id = aws_security_group.instancesg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Inbound rule for port 3000 (Custom)
resource "aws_vpc_security_group_ingress_rule" "allow_tcp_3000" {
  security_group_id = aws_security_group.instancesg.id
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Inbound rule for port 22 (SSH)
resource "aws_vpc_security_group_ingress_rule" "allow_tcp_22" {
  security_group_id = aws_security_group.instancesg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.instancesg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}