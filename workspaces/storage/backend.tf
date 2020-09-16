#####################################
# Management of tfstate
#####################################
terraform {
  backend "s3" {
    bucket = "storage-tfstate"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
}
