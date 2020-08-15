variable "identifiers" {}
variable "policy" {}

resource "aws_iam_role" "ec2_assume_role" {
  name               = ec2_assume_role
  assume_role_policy = var.policy
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.identifiers
    }
  }
}

data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeRegions"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "allow_describe_regions" {
  name   = "allow_describe_regions"
  policy = data.aws_iam_policy_document.allow_describe_regions.json
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.ec2_assume_role.name
  policy_arn = aws_iam_policy.allow_describe_regions.arn
}

output "iam_role_arn" {
  value = aws_iam_role.ec2_assume_role.arn
}

output "iam_role_name" {
  value = aws_iam_role.ec2_assume_role.name
}
