terraform {
  required_providers {
    godaddy = {
      source  = "n3integration/godaddy"
      version = "~> 1.9.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "godaddy" {
  key    = "e5NPwrdhq68m_PkvEPmteDJi2HQLRiAawvC"
  secret = "Uch25ENz6Hpwp5yzZ5Uct2"
}

provider "aws" {
  region = "us-east-1"
}


output "elb" {
  value = module.dns_records.elb.dns_name
}

locals {
  project              = "winmoney-stage"
  service_account_name = module.common.service_account_name
  balancer_name        = "a02a312bbb50d46e8a24b31c6175c0b4"
  domain_name          = "playtowinapps.com"
  record_type          = "CNAME"
  ttl                  = 600
  dns_prefix           = "winmoney"
  prefix               = "winmoney"
  environment          = "-stage"
  db_host_wr           = "winmoney-stage-db.cbgejhy5hdtp.us-east-1.rds.amazonaws.com"
  db_host_rr           = "winmoney-stage-db.cbgejhy5hdtp.us-east-1.rds.amazonaws.com"
  repository           = "max3014"
  tag                  = "win-v2.69"
  dns_records = [
    "${local.dns_prefix}-auth${local.environment}.${local.domain_name}",
    "${local.dns_prefix}-balance${local.environment}.${local.domain_name}",
    "${local.dns_prefix}-earning${local.environment}.${local.domain_name}",
    "${local.dns_prefix}-leaderboard${local.environment}.${local.domain_name}",
    "${local.dns_prefix}-schedule${local.environment}.${local.domain_name}"
    //"${local.dns_prefix}-appsflyer-provider${local.environment}.${local.domain_name}",
    //"${local.dns_prefix}-stats${local.environment}.${local.domain_name}",
    //"${local.dns_prefix}-reward${local.environment}.${local.domain_name}",
    //"${local.dns_prefix}-panel${local.environment}.${local.domain_name}"
  ]
  dns_recrord_name = [
    "${local.dns_prefix}-auth${local.environment}",
    "${local.dns_prefix}-balance${local.environment}",
    "${local.dns_prefix}-earning${local.environment}",
    "${local.dns_prefix}-leaderboard${local.environment}",
    "${local.dns_prefix}-schedule${local.environment}"
  ]
}

module "dns_records" {
  source           = "github.com/Boints/terraform-modules/dns//"
  dns_recrord_name = local.dns_recrord_name
  balancer_name    = local.balancer_name
  domain           = local.domain_name
  record_type      = local.record_type
  ttl              = local.ttl
}

module "common" {
  source     = "github.com/Boints/terraform-modules/common/"
  project    = local.project
  prefix     = local.prefix
  db_host_wr = local.db_host_wr
  db_host_rr = local.db_host_rr

  domain_name = local.domain_name

  dns_records = local.dns_records
}

module "auth" {
  source = "github.com/Boints/terraform-modules/microservices/"

  project                   = local.project
  service_account_name      = local.service_account_name
  prefix                    = local.prefix
  microservice              = "auth"
  image                     = "${local.repository}/auth:${local.tag}"
  deployment_replicas       = 1
  microservice_dns_record   = "${local.dns_prefix}-auth${local.environment}.${local.domain_name}"
  deployment_cpu_limit      = "400m"
  deployment_memory_limit   = "2560Mi"
  deployment_cpu_request    = "100m"
  deployment_memory_request = "1700Mi"

  depends_on = [
    module.common
  ]
}

module "balance" {
  source = "github.com/Boints/terraform-modules/microservices/"

  project                   = local.project
  service_account_name      = local.service_account_name
  prefix                    = local.prefix
  microservice              = "balance"
  image                     = "${local.repository}/balance:${local.tag}"
  deployment_replicas       = 1
  microservice_dns_record   = "${local.dns_prefix}-balance${local.environment}.${local.domain_name}"
  deployment_cpu_limit      = "400m"
  deployment_memory_limit   = "512Mi"
  deployment_cpu_request    = "100m"
  deployment_memory_request = "256Mi"

  depends_on = [
    module.common
  ]
}

module "earning" {
  source = "github.com/Boints/terraform-modules/microservices/"

  project                   = local.project
  service_account_name      = local.service_account_name
  prefix                    = local.prefix
  microservice              = "earning"
  image                     = "${local.repository}/earning:${local.tag}"
  deployment_replicas       = 1
  microservice_dns_record   = "${local.dns_prefix}-earning${local.environment}.${local.domain_name}"
  deployment_cpu_limit      = "400m"
  deployment_memory_limit   = "512Mi"
  deployment_cpu_request    = "100m"
  deployment_memory_request = "256Mi"

  depends_on = [
    module.common
  ]
}

module "leaderboard" {
  source = "github.com/Boints/terraform-modules/microservices/"

  project                   = local.project
  service_account_name      = local.service_account_name
  prefix                    = local.prefix
  microservice              = "leaderboard"
  image                     = "${local.repository}/leaderboard:${local.tag}"
  deployment_replicas       = 1
  microservice_dns_record   = "${local.dns_prefix}-leaderboard${local.environment}.${local.domain_name}"
  deployment_cpu_limit      = "400m"
  deployment_memory_limit   = "512Mi"
  deployment_cpu_request    = "100m"
  deployment_memory_request = "256Mi"

  depends_on = [
    module.common
  ]
}

module "schedule" {
  source = "github.com/Boints/terraform-modules/microservices/"

  project                   = local.project
  service_account_name      = local.service_account_name
  prefix                    = local.prefix
  microservice              = "schedule"
  image                     = "${local.repository}/schedule:${local.tag}"
  deployment_replicas       = 1
  microservice_dns_record   = "${local.dns_prefix}-schedule${local.environment}.${local.domain_name}"
  deployment_cpu_limit      = "400m"
  deployment_memory_limit   = "512Mi"
  deployment_cpu_request    = "100m"
  deployment_memory_request = "256Mi"

  depends_on = [
    module.common
  ]
}
/*
module "appsflyer-provider" {
  source = "github.com/Boints/terraform-modules/microservices/"

  project                   = local.project
  service_account_name      = local.service_account_name
  prefix     = local.prefix
  microservice              = "appsflyer-provider"
  deployment_replicas       = 1
  microservice_dns_record   = "${local.dns_prefix}-appsflyer-provider${local.environment}.${local.domain_name}"
  deployment_cpu_limit      = "1m"
  deployment_memory_limit   = "1Gi"
  deployment_cpu_request    = "0.5m"
  deployment_memory_request = "256Mi"

  depends_on = [
    module.common
  ]
}

module "stats" {
  source = "github.com/Boints/terraform-modules/microservices/"

  project                   = local.project
  service_account_name      = local.service_account_name
  prefix     = local.prefix
  microservice              = "stats"
  deployment_replicas       = 1
  microservice_dns_record   = "${local.dns_prefix}-stats${local.environment}.${local.domain_name}"
  deployment_cpu_limit      = "1m"
  deployment_memory_limit   = "1Gi"
  deployment_cpu_request    = "0.5m"
  deployment_memory_request = "256Mi"

  depends_on = [
    module.common
  ]
}

module "sentinel" {
  source = "github.com/Boints/terraform-modules/microservices/"

  project                   = local.project
  service_account_name      = local.service_account_name
  prefix                    = local.prefix
  service_port              = 9464
  service_target_port       = 9464
  microservice              = "sentinel"
  image                     = "${local.repository}/sentinel:${local.tag}"
  deployment_replicas       = 1
  microservice_dns_record   = "${local.dns_prefix}-sentinel{local.environment}.${local.domain_name}"
  app_protocol              = "http"
  deployment_cpu_limit      = "1m"
  deployment_memory_limit   = "1Gi"
  deployment_cpu_request    = "0.5m"
  deployment_memory_request = "256Mi"

  depends_on = [
    module.common
  ]
}

module "reward" {
  source = "github.com/Boints/terraform-modules/microservices/"

  project                   = local.project
  service_account_name      = local.service_account_name
  prefix     = local.prefix
  microservice              = "reward"
  deployment_replicas       = 1
  microservice_dns_record   = "${local.dns_prefix}-reward${local.environment}.${local.domain_name}"
  deployment_cpu_limit      = "1m"
  deployment_memory_limit   = "1Gi"
  deployment_cpu_request    = "0.5m"
  deployment_memory_request = "256Mi"

  depends_on = [
    module.common
  ]
}
*/
