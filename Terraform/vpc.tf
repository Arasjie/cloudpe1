# vpc.tf 
# Create VPC/Subnet/Security Group/Network ACL

provider "aws" {
  version = "~> 2.0"
  region = var.region
}

# create the VPC
resource "aws_vpc" "PE_CNA" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
tags = {
    Name = "PE CNA"
 }

} # end resource

# create the Subnet
resource "aws_subnet" "PE_CNA_Subnet" {
  vpc_id                  = aws_vpc.PE_CNA.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
tags = {
   Name = "PE CNA Subnet"
}
} # end resource

# Create the PE CNA CloudLoadBalancer Security Group
resource "aws_security_group" "PE_CNA_CloudLoadBalancer_Security_Group" {
  vpc_id       = aws_vpc.PE_CNA.id
  name         = "PE CNA CloudLoadBalancer"
  description  = "Allow http and ssh"
  
  # allow ingress of port 80
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  } 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["193.190.154.176/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["193.190.154.175/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["193.190.154.173/32"]
  }
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "PE CNA CloudLoadBalancer Security Group"
   Description = "PE CNA CloudLoadBalancer Security Group"
}
} # end resource

# Create the PE CNA Cloud Webserver Security Group
resource "aws_security_group" "PE_CNA_CloudWebserver_Security_Group" {
  vpc_id       = aws_vpc.PE_CNA.id
  name         = "PE CNA CloudWebserver"
  description  = "Cloud Webserver"
  
  # allow ingress of port 3306
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" 
    #source_security_group_id = aws-load-balancer
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["193.190.154.176/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["193.190.154.175/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["193.190.154.173/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp" 
    cidr_blocks = ["193.190.154.174/32"]
  }
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "PE CNA CloudWebserver Security Group"
   Description = "PE CNA CloudWebserver Security Group"
}
} # end resource

# create VPC Network access control list
resource "aws_network_acl" "PE_CNA_Security_ACL" {
  vpc_id = aws_vpc.PE_CNA.id
  subnet_ids = [ aws_subnet.PE_CNA_Subnet.id ]# allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 80
    to_port    = 80
  }
  
  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  
  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22 
    to_port    = 22
  }
  
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80  
    to_port    = 80 
  }
 
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
tags = {
    Name = "PE CNA ACL"
}
} # end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "PE_CNA_GW" {
 vpc_id = aws_vpc.PE_CNA.id
tags = {
        Name = "PE CNA Internet Gateway"
}
} # end resource

# Create the Route Table
resource "aws_route_table" "PE_CNA_route_table" {
 vpc_id = aws_vpc.PE_CNA.id
 tags = {
        Name = "PE CNA Route Table"
}
} # end resource

# Create the Internet Access
resource "aws_route" "PE_CNA_internet_access" {
  route_table_id         = aws_route_table.PE_CNA_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.PE_CNA_GW.id
} 

# end resource# Associate the Route Table with the Subnet
resource "aws_route_table_association" "PE_CNA_association" {
  subnet_id      = aws_subnet.PE_CNA_Subnet.id
  route_table_id = aws_route_table.PE_CNA_route_table.id
} # end resource# end vpc.tf
