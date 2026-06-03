variable "name" {
  description = "Cluster and environment base name."
  type        = string
  default     = "hiive-demo"
}

variable "region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-west-2"
}

variable "namespace" {
  description = "Namespace for the demo application."
  type        = string
  default     = "hiive-demo"
}

variable "app_image_tag" {
  description = "Image tag written to private ECR and referenced by the workload."
  type        = string
  default     = "demo"
}

variable "source_image" {
  description = "Public image that gets mirrored into private ECR during deployment."
  type        = string
  default     = "public.ecr.aws/docker/library/nginx:1.27-alpine"
}

variable "seed_ecr_image" {
  description = "Whether Terraform should mirror the public source image into private ECR using local Docker and AWS CLI."
  type        = bool
  default     = false
}

variable "replicas" {
  description = "Replica count for the demo application."
  type        = number
  default     = 2
}

variable "route53_zone_name" {
  description = "Public Route53 hosted zone name, for example example.com."
  type        = string
}

variable "app_domain_name" {
  description = "Fully qualified domain name for the application, for example hiive-demo.example.com."
  type        = string
}

variable "aws_load_balancer_controller_chart_version" {
  description = "Helm chart version for AWS Load Balancer Controller."
  type        = string
  default     = "1.11.0"
}

variable "external_dns_chart_version" {
  description = "Helm chart version for ExternalDNS."
  type        = string
  default     = "1.15.2"
}
