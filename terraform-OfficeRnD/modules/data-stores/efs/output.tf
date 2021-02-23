output "efs_arn" {
  description = "EFS ARN"
  value       = aws_efs_file_system.wordpress-efs.arn
}

output "efs_id" {
  description = "EFS ID"
  value       = aws_efs_file_system.wordpress-efs.id
}

output "efs_dns_name" {
  description = "EFS DNS name"
  value       = aws_efs_file_system.wordpress-efs.dns_name
}

output "security_group_efs_id" {
  description = "EFS Security Group ID"
  value       = aws_security_group.efs.id
}

output "security_group_efs_arn" {
  description = "EFS Security Group ARN"
  value       = aws_security_group.efs.arn
}

output "security_group_efs_name" {
  description = "EFS Security Group name"
  value       = aws_security_group.efs.name
}

output "mount_target_ids" {
  description = "List of EFS mount target IDs (one per Availability Zone)"
  value       = coalescelist(aws_efs_mount_target.wordpress-efs.*.id, [""])
}

