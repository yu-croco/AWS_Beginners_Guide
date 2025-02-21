variable "your_home_ip" {
  type        = string
  description = "勉強用のリソースであるため、アクセス元を絞るために利用している"
}

variable "your_key_name" {
  type        = string
  description = <<EOT
  EC2にSCPするためにAWSコンソールから作成したKey名。
  以下のサイトを参考にしてKeyの作成を行う。
  https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/createkeypairs.html#havingec2createyourkeypair
EOT
}

variable "owner" {
  type        = string
  description = "tags_allで利用しており、リソースの作者を指定する。"
}

locals {
  your_home_cidr = "${var.your_home_ip}/32"
}
