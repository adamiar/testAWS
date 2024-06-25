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


resource "aws_security_group" "allowed_ip" {
  name = "allow_ips"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ips]
  }
}