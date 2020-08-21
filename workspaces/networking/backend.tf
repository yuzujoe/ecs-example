#####################################
# Management of tfstate
#####################################
terraform {
  backend "s3" {
    bucket = "networking-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}

