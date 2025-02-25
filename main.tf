# Create a VPC in us-east-1a
resource "aws_vpc" "tf_webvpc" {
  cidr_block = "10.123.0.0/16"

  tags = {
    Name = "tf_webvpc"
  }
}

resource "aws_subnet" "tf_webvpc_subnet" {
  vpc_id                  = aws_vpc.tf_webvpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "tf_webvpc_subnet"
  }
}


resource "aws_route_table_association" "web_public_access" {
  subnet_id      = aws_subnet.tf_webvpc_subnet.id
  route_table_id = aws_vpc.tf_webvpc.default_route_table_id

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.tf_webvpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_internet_gateway" "tf_webvpc_igw" {
  vpc_id = aws_vpc.tf_webvpc.id

  tags = {
    Name = "tf_webvpc_igw"
  }
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_vpc.tf_webvpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_webvpc_igw.id
}


#Create an EC2 Instance in webvpc
data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}
resource "aws_key_pair" "tf_web_key" {
  key_name   = "tf_key"
  public_key = var.ssh_public_key
}
              
resource "aws_instance" "server" {
  count                  = 3
  ami                    = data.aws_ami.amazon.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.tf_webvpc_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = aws_key_pair.tf_web_key.id
  user_data = <<-EOF
    #!/bin/bash
    echo "Setting up instance ${count.index}"

    ${lookup(var.user_data, count.index, "")}
  EOF 
  tags = {
    Name = join("_", [ "Server", count.index ])
  }
}



