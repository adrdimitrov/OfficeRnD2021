output "bastion_key_pair_key_name" {
  description = "The key pair name."
  value       = concat(aws_key_pair.bastion_key.*.key_name, [""])[0]
}

output "bastion_key_pair_key_pair_id" {
  description = "The key pair ID."
  value       = concat(aws_key_pair.bastion_key.*.key_pair_id, [""])[0]
}

output "this_key_pair_fingerprint" {
  description = "The MD5 public key fingerprint as specified in section 4 of RFC 4716."
  value       = concat(aws_key_pair.bastion_key.*.fingerprint, [""])[0]
}

output "vpc_id" {
  description = "The id of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnets" {
  description = "Public subnet ids of the custom VPC"
  value       = aws_subnet.public.*.id
}

output "private_subnets" {
  description = "Private subnet ids of the custom VPC"
  value       = aws_subnet.private.*.id
}

