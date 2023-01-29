variable "your_home_ip" {
  type        = string
  description = "勉強用のリソースであるため、アクセス元を絞るために利用している"
}

locals {
  your_home_cidr = "${var.your_home_ip}/32"
}
