#!/bin/bash
yum update -y
amazon-linux-extras enable php7.4
yum install -y php php-mysqlnd httpd wget unzip amazon-efs-utils

systemctl enable httpd
systemctl start httpd

cd /var/www/html
wget https://wordpress.org/latest.zip
unzip latest.zip
cp -r wordpress/* .
rm -rf wordpress latest.zip

# Mount EFS
mkdir -p /var/www/html/wp-content
mount -t efs ${efs_dns}:/ /var/www/html/wp-content
echo "${efs_dns}:/ /var/www/html/wp-content efs defaults,_netdev 0 0" >> /etc/fstab

# Create wp-config
cat <<EOF > /var/www/html/wp-config.php
<?php
define( 'DB_NAME', '${db_name}' );
define( 'DB_USER', '${db_user}' );
define( 'DB_PASSWORD', '${db_password}' );
define( 'DB_HOST', '${rds_endpoint}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
EOF

chown -R apache:apache /var/www/html
