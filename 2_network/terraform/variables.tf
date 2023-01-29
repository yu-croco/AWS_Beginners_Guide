variable "your_home_ip" {
  type        = string
  description = "勉強用のリソースであるため、アクセス元を絞るために利用している"
}

variable "your_key_name" {
  type        = string
  description = <<EOT
  EC2にSSHログインするためにAWSコンソールから作成したKey名。
  以下のサイトを参考にしてKeyの作成を行う。
  https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/create-key-pairs.html#having-ec2-create-your-key-pair
EOT
}

locals {
  your_home_cidr = "${var.your_home_ip}/32"
}
