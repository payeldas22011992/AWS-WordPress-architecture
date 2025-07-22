resource "aws_efs_file_system" "this" {
  creation_token = "${var.name}-efs"
  encrypted      = true

  tags = {
    Name = "${var.name}-efs"
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [var.sg_id]
}
