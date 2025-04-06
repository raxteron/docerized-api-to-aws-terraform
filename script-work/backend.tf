terraform {
  backend "s3" {
    bucket  = "trf-st-docker-hello-api"
    key     = "hello-world-api-script/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}