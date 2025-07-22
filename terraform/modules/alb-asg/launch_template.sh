#!/bin/bash
yum update -y
amazon-linux-extras enable php7.4
yum install -y php php-mysqlnd httpd mariadb-server wget unzip

systemctl start httpd
systemctl enable httpd

cd /var/www/html
wget https://wordpress.org/latest.zip
unzip latest.zip
cp -r wordpress/* .
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html


# Install EFS utils
yum install -y amazon-efs-utils

# Mount EFS
mkdir -p /var/www/html/wp-content
mount -t efs ${efs_id}:/ /var/www/html/wp-content

# Auto-mount on reboot
echo "${efs_id}:/ /var/www/html/wp-content efs defaults,_netdev 0 0" >> /etc/fstab
