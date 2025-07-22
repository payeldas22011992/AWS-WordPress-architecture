output "endpoint" {
  value = aws_db_instance.this[0].endpoint
  condition = length(aws_db_instance.this) > 0
}

output "replica_endpoint" {
  value = aws_db_instance.replica[0].endpoint
  condition = length(aws_db_instance.replica) > 0
}
