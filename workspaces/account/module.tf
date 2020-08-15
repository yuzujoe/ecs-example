module "describe_regions_for_ec2" {
  source      = "./iam_role"
  identifiers = "ec2.amazonaws.com"
  policy      = data.aws_iam_policy_document.allow_describe_regions.json
}
