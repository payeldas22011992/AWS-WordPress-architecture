resource "aws_instance" "wordpress" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = true
  key_name = var.key_name

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = var.instance_name
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
