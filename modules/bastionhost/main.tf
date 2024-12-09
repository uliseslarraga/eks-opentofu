## AWS SSH Key Pair
resource "aws_key_pair" "ec2-bastion-host-key-pair" {
  key_name = "ec2-bastion-host-key-pair-${var.environment}"
  public_key = file("./ssh-key/id_rsa.pub")
}

resource "aws_security_group" "ec2-bastion-sg" {
  description = "EC2 Bastion Host Security Group"
  name = "ec2-bastion-sg-${var.environment}"
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Open to Public Internet"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "IPv4 route Open to Public Internet"
  }
}

## EC2 Bastion Host Elastic IP
resource "aws_eip" "ec2-bastion-host-eip" {
    vpc = true
    tags = {
        Name = "ec2-bastion-host-eip-${var.environment}"
    }
}

resource "aws_instance" "ec2-bastion-host" {
    ami = "ami-0c80e2b6ccb9ad6d1"
    instance_type = "t2.micro"
    key_name = aws_key_pair.ec2-bastion-host-key-pair.key_name
    vpc_security_group_ids = [ aws_security_group.ec2-bastion-sg.id ]
    subnet_id = var.public_subnet_id
    associate_public_ip_address = false
    root_block_device {
      volume_size = 8
      delete_on_termination = true
      volume_type = "gp2"
      encrypted = true
      tags = {
        Name = "ec2-bastion-host-root-volume-${var.environment}"
      }
    }
    credit_specification {
      cpu_credits = "standard"
    }
    tags = {
        Name = "ec2-bastion-host-${var.environment}"
    }
    lifecycle {
      ignore_changes = [ 
        associate_public_ip_address,
       ]
    }
}

## EC2 Bastion Host Elastic IP Association
resource "aws_eip_association" "ec2-bastion-host-eip-association" {
    instance_id   = aws_instance.ec2-bastion-host.id
    allocation_id = aws_eip.ec2-bastion-host-eip.id
    depends_on    = [
        aws_instance.ec2-bastion-host,
        aws_eip.ec2-bastion-host-eip
    ]
}