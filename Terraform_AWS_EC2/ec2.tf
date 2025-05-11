# ec2.tf

resource "aws_instance" "ubuntu_instance" {
  ami                    = "ami-04f167a56786e4b09" # Ubuntu 20.04 AMI ID
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0332476f368aed74c" # Hardcoded subnet ID for Ubuntu instance
  key_name               = "alitestkey"
  security_groups        = [aws_security_group.ubuntu_sg.id] # Assign Ubuntu security group
  tags = {
    Name = "tf_created_ec2_ubuntu"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/ubuntu_userdata.sh", {})
}

resource "aws_instance" "amazon_linux_2_instance" {
  ami                    = "ami-096af71d77183c8f8" # Amazon Linux 2 AMI ID
  instance_type          = "t2.micro"
  subnet_id              = "subnet-0fb154ef283fe544b" # Hardcoded subnet ID for Amazon Linux 2 instance
  key_name               = "alitestkey"
  security_groups        = [aws_security_group.amazon_linux_sg.id] # Assign Amazon Linux 2 security group
  tags = {
    Name = "tf_created_ec2_amazon_linux_2"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/al2_userdata.sh", {})
}

resource "aws_instance" "amazon_linux_2023_instance" {
  ami                    = "ami-058a8a5ab36292159" # Amazon Linux 2023 AMI ID
  instance_type          = "t2.micro"
  subnet_id              = "subnet-07e775f8893398c0f" # Hardcoded subnet ID for Amazon Linux 2023 instance
  key_name               = "alitestkey"
  security_groups        = [aws_security_group.amazon_linux_sg.id] # Assign Amazon Linux 2023 security group
  tags = {
    Name = "tf_created_ec2_amazon_linux_2023"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/al2023_userdata.sh", {})
}
