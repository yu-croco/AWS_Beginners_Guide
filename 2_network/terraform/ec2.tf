resource "aws_instance" "infra_study" {
  ami                         = "ami-06ee4e2261a4dc5c3" # Amazon Linux 2 Kernel 5.10 AMI 2.0.20230119.1 x86_64 HVM gp
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.infra_study_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.infra_study_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.this.name
  count                       = 1
  associate_public_ip_address = true
  user_data                   = file("./user_data.sh")
  tags = {
    Name = "infra-study-${var.owner}"
  }
}
