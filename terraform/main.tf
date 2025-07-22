provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
  name    = "global-wordpress-vpc"
  cidr    = var.vpc_cidr
  azs     = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP/HTTPS traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "wp_alb" {
  name               = "wp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_launch_template" "wordpress_lt" {
  name_prefix   = "wp-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(file("user_data.sh"))
}

resource "aws_autoscaling_group" "wp_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = module.vpc.private_subnets
  launch_template {
    id      = aws_launch_template.wordpress_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "wordpress"
    propagate_at_launch = true
  }
}

resource "aws_efs_file_system" "wp_efs" {
  creation_token = "wordpress-efs"
  tags = {
    Name = "WordPress-EFS"
  }
}

resource "aws_db_instance" "wp_rds" {
  identifier              = "wp-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  name                    = var.db_name
  username                = var.db_user
  password                = var.db_password
  publicly_accessible     = false
  multi_az                = true
  skip_final_snapshot     = true
}

resource "aws_s3_bucket" "wp_media" {
  bucket = "wordpress-media-bucket"
  acl    = "private"
}
