provider "datadog" {}

locals {
  tags = [
    "env:${var.env}",
    "service:${var.service_name}",
    "managed_by:terraform",
    "team:sre",
  ]
}
