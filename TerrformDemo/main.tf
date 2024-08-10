provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}
resource "aws_instance" "tfvm1" {
  ami = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.websg.id ]
  user_data = <<-EOF
                #!/bin/bash
                echo "Thi is  TERRAFORM demo app" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    tags = {
      Name = "WEB-demo"
    }
}
resource "aws_security_group" "websg" {
  name = "web-sg01"
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
output "instance_ips" {
  value = aws_instance.tfvm1.public_ip
}