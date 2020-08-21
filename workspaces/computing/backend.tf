#####################################
# Management of tfstate
#####################################
terraform {
  backend "s3" {
    bucket = "computing-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "account" {
  backend = "s3"

  config = {
    bucket = "account-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = "networking-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}
