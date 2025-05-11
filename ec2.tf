#ec2 instance
resource "aws_instance" "loading" {
  ami           = "ami-06b6e5225d1db5f46"
  instance_type = "t2.micro"
subnet_id   = aws_subnet.crm-web-sn.id
key_name = "almas.pem"
vpc_security_group_ids = aws_security_group.crm-web-security.id
user_data = file("setup.sh")
}


