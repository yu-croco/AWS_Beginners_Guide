resource "aws_iam_role" "this" {
  name               = "infra-study"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_for_worker_node.json
}

data "aws_iam_policy_document" "assume_role_policy_for_worker_node" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Session Managerを利用しつつ使うための権限
# see: https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/session-manager-getting-started-instance-profile.html
resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.this.name
}

resource "aws_iam_instance_profile" "this" {
  name = "infra-study"
  role = aws_iam_role.this.name
}
