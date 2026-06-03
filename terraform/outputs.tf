output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "private_ecr_repository_url" {
  description = "ECR repository for the mirrored demo image."
  value       = aws_ecr_repository.app.repository_url
}

output "internal_service_hostname" {
  description = "Application hostname managed through Route53 and ExternalDNS."
  value       = var.app_domain_name
}

output "alb_hostname" {
  description = "Underlying ALB hostname created by AWS Load Balancer Controller."
  value       = try(kubernetes_ingress_v1.app.status[0].load_balancer[0].ingress[0].hostname, null)
}
