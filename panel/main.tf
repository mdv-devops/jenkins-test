terraform {
  backend "s3" {
    bucket         = "boints-terraform-state"
    key            = "kubernetes/winmoney-stage/frontend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate_locks"
    encrypt        = true
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

data "terraform_remote_state" "common_data" {
  backend = "s3"

  config = {
    bucket = "boints-terraform-state"
    key    = "kubernetes/winmoney-stage/terraform.tfstate"
    region = "us-east-1"
  }
}

output "com_data" {
  value = data.terraform_remote_state.common_data.outputs
}

locals {
  domain_name          = "playtowinapps.com"
  dns_prefix           = "winmoney"
  prefix               = "winmoney"
  environment          = "-stage"
  repository           = "max3014"
  tag                  = "win-v3.7"
  service_account_name = data.terraform_remote_state.common_data.outputs.service_account_name
  config_map_name      = data.terraform_remote_state.common_data.outputs.config_map_name
  namespace            = data.terraform_remote_state.common_data.outputs.namespace
  gateway              = data.terraform_remote_state.common_data.outputs.gateway
}

module "panel" {
  source = "github.com/Boints/terraform-modules/microservices/"

  namespace                 = local.namespace
  config_map_name           = local.config_map_name
  gateway                   = local.gateway
  service_account_name      = local.service_account_name
  prefix                    = local.prefix
  command                   = []
  args                      = []
  microservice              = "panel"
  image                     = "${local.repository}/panel:${local.tag}"
  deployment_replicas       = 1
  microservice_dns_record   = "${local.dns_prefix}-panel${local.environment}.${local.domain_name}"
  app_protocol              = "http"
  deployment_cpu_limit      = "400m"
  deployment_memory_limit   = "512Mi"
  deployment_cpu_request    = "100m"
  deployment_memory_request = "256Mi"
  container_port            = 80
  service_port              = 80
  readiness_probe = {
    http_get = {
      path   = "/"
      port   = 80
      scheme = "HTTP"
    }
    initial_delay_seconds = 30
    period_seconds        = 60
    success_threshold     = 1
    timeout_seconds       = 5
    failure_threshold     = 5
  }
  liveness_probe = {
    http_get = {
      path   = "/"
      port   = 80
      scheme = "HTTP"
    }
    initial_delay_seconds = 30
    period_seconds        = 60
    success_threshold     = 1
    timeout_seconds       = 5
    failure_threshold     = 5
  }
}
