output "efs_id" {
  value = aws_efs_file_system.wordpress.id
}

output "efs_dns" {
  value = aws_efs_file_system.wordpress.dns_name
}
