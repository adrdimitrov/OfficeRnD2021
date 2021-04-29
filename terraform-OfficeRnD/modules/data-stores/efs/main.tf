resource "aws_security_group" "efs" {
  name   = var.efs_name
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_efs_ssh_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.efs.id

  from_port   = "22"
  to_port     = "22"
  protocol    = "tcp"
  cidr_blocks = var.efs_inbound_ips
}

resource "aws_security_group_rule" "allow_efs_nfs_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.efs.id

  from_port   = "2049"
  to_port     = "2049"
  protocol    = "tcp"
  cidr_blocks = var.efs_inbound_ips
}


resource "aws_efs_file_system" "wordpress-efs" {
  creation_token = var.efs_name
  encrypted      = var.encrypted
  kms_key_id     = var.kms_key_id

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_efs_mount_target" "wordpress-efs" {
  count           = length(var.subnet_ids) > 0 ? length(var.subnet_ids) : 0

  file_system_id  = aws_efs_file_system.wordpress-efs.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [
    aws_security_group.efs.id
  ]
}
