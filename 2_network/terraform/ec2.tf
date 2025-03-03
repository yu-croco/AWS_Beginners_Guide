resource "aws_instance" "infra_study" {
  ami                         = "ami-09a73d1fbb2515f95" # Amazon Linux 2 Kernel 5.10 AMI 2.0.20250220.0 x86_64 HVM gp2
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.this.key_name
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

locals {
  public_key_file  = "./.key_pair/${var.owner}_infra-study.id_rsa.pub"
  private_key_file = "./.key_pair/${var.owner}_infra-study.id_rsa"
}

resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#local_fileのリソースを指定するとterraformを実行するディレクトリ内でファイル作成やコマンド実行が出来る。
resource "local_file" "private_key_pem" {
  filename = local.private_key_file
  content  = tls_private_key.keygen.private_key_pem
  provisioner "local-exec" {
    command = "chmod 600 ${local.private_key_file}"
  }
}

resource "local_file" "public_key_openssh" {
  filename = local.public_key_file
  content  = tls_private_key.keygen.public_key_openssh
  provisioner "local-exec" {
    command = "chmod 600 ${local.public_key_file}"
  }
}

resource "aws_key_pair" "this" {
  key_name   = "${var.owner}-infra-study"
  public_key = tls_private_key.keygen.public_key_openssh
}
