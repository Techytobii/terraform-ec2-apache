resource "aws_instance" "web" {
  ami                    = "ami-0c02fb55956c7d316"  # Amazon Linux 2 (Free tier in us-east-1)
  instance_type          = "t2.micro"
  user_data              = var.user_data
  vpc_security_group_ids = [var.security_group_id]
  subnet_id = var.subnet_id


  tags = {
    Name = "ApacheEC2"
  }
}
