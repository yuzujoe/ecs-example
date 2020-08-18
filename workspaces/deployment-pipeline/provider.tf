provider "aws" {
  version = "~> 2.8"
  region  = "ap-northeast-1"
}

provider "github" {
  organization = "your-github-name"
}
