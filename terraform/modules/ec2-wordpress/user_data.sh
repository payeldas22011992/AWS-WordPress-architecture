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
