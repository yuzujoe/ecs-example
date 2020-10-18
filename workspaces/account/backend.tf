#####################################
# Management of tfstate
#####################################
terraform {
  backend "s3" {
    bucket = "joe-dev-tfstate"
    key    = "terraform-tfstate/aws/account/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
