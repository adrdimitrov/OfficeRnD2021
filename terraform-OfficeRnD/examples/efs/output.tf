output "efs_arn" {
  description = "EFS ARN"
  value       = module.efs.efs_arn
}

output "efs_id" {
  description = "EFS ID"
  value       = module.efs.efs_id
}

output "efs_dns_name" {
  description = "EFS DNS name"
  value       = module.efs.efs_dns_name
}

output "security_group_efs_id" {
  description = "EFS Security Group ID"
  value       = module.efs.security_group_efs_id
}

output "security_group_efs_arn" {
  description = "EFS Security Group ARN"
  value       = module.efs.security_group_efs_arn
}

output "security_group_efs_name" {
  description = "EFS Security Group name"
  value       = module.efs.security_group_efs_name
}

output "mount_target_ids" {
  description = "List of EFS mount target IDs (one per Availability Zone)"
  value       = module.efs.mount_target_ids
}
