resource "aws_s3_bucket" "wp_bucket" {
  bucket = "${var.name}-wp-media"

  tags = {
    Name = "${var.name}-wp-bucket"
  }
}
