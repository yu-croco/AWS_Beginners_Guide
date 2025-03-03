variable "your_home_ip" {
  type        = string
  description = "勉強用のリソースであるため、アクセス元を絞るために利用している"
}

variable "owner" {
  type        = string
  description = "tags_allで利用しており、リソースの作者を指定する。"
}

locals {
  your_home_cidr = "${var.your_home_ip}/32"
}
