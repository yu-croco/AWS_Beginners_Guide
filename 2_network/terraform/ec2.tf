resource "aws_instance" "infra_study" {
  ami           = "ami-0cc75a8978fbbc969" # Amazon Linux 2
  instance_type = "t2.micro"
  # create secret key and set the key name on 'key_name' below
  # see: https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/ec2-key-pairs.html
  key_name                    = ""
  subnet_id                   = aws_subnet.infra_study_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.infra_study_sg.id]
  iam_instance_profile        = "infra-study"
  count                       = 1
  associate_public_ip_address = true
  user_data                   = file("./user_data.sh")
  tags = {
    Name = "infra-study"
  }
}
