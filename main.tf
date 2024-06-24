resource "aws_instance" "test_instance" {
  ami           = "ami-0cc9d768a8b3c6f55"  # Ubuntu Server 20.04
  instance_type = "t2.micro"               # Instance type eligible for free tier
  subnet_id     = data.aws_subnet.default_subnet.id
  tags = {
    Name = "TagsTest"
  }
}


data "aws_subnet" "default_subnet" {
  id = "subnet-013bb59a4e805fd0d"
}