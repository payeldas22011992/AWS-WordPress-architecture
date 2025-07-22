output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "wp_sg_id" {
  value = aws_security_group.wordpress_sg.id
}