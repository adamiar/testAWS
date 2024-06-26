data "aws_subnet" "default_subnet" {
  id = "subnet-013bb59a4e805fd0d"
}


resource "aws_instance" "test_instance" {
  ami           = "ami-0cc9d768a8b3c6f55" # Ubuntu Server 20.04
  instance_type = "t2.micro"              # Instance type eligible for free tier
  subnet_id     = data.aws_subnet.default_subnet.id
  tags = {
    Name = "InstanceTest"
  }
  vpc_security_group_ids = [aws_security_group.allowed_ip.id] # Applying security group to instance network interface
  key_name               = "test_instance"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  }


resource "null_resource" "docker_install" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("../../private.pem")
      host        = aws_instance.test_instance.public_ip
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sudo sh get-docker.sh",
      "sudo curl -L 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo usermod -aG docker ubuntu",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]
  }
}


resource "aws_security_group" "allowed_ip" {
  name = "allow_ips"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ips]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}