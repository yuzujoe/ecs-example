#####################################
# Management of tfstate
#####################################
terraform {
  backend "s3" {
    bucket = "joe-dev-vpc-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}
