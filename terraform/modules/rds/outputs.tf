output "endpoint" {
  value = aws_db_instance.primary[0].endpoint
  condition = length(aws_db_instance.primary) > 0
}

output "replica_endpoint" {
  value = aws_db_instance.replica[0].endpoint
  condition = length(aws_db_instance.replica) > 0
}

output "db_instance_arn" {
  value = aws_db_instance.primary[0].arn
  condition = length(aws_db_instance.primary) > 0
}
