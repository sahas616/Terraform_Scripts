output "cluster_id" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "region" {
  value = var.aws_region
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}