output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "efs_dns" {
  value = aws_efs_file_system.this.dns_name
}
