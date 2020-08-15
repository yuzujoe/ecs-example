#####################
# IAM Policy
#####################

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

#####################
# IAM Role
#####################

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_assume_role" {
  name               = "ec2_assume_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ec2_assume_role_attachment" {
  policy_arn = aws_iam_policy.allow_describe_regions.arn
  role       = aws_iam_role.ec2_assume_role.name
}
