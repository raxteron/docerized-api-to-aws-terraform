terraform {
  backend "s3" {
    bucket  = "trf-st-docker-hello-api"
    key     = "hello-world-api-manual/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}