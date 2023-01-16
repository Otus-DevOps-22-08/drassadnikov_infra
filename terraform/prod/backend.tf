terraform {

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "drassadnikov-tf-state"
    region     = "ru-central1"
    key        = "prod/terraform.tfstate"
    access_key = "YCAJEcoJme8fBDMzorm-q19Ay"
    secret_key = "YCNcoZod-AWqPTvph5SKtFUgcAav51iDpd1b6Gzg"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
