output "bastion_key_pair_key_name" {
  description = "The key pair name."
  value       = module.vpc.bastion_key_pair_key_name
}

output "bastion_key_pair_key_pair_id" {
  description = "The key pair ID."
  value       = module.vpc.bastion_key_pair_key_pair_id
}

output "this_key_pair_fingerprint" {
  description = "The MD5 public key fingerprint as specified in section 4 of RFC 4716."
  value       = module.vpc.this_key_pair_fingerprint
}

output "bastion_private_sg" {
  description = "Security group allowing inbound traffic on port 22 from bastion host"
  value       = module.vpc.bastion_private_sg
}
