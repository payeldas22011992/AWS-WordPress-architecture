#!/bin/bash
apt update -y
apt install apache2 php php-mysql mysql-client -y
systemctl start apache2
systemctl enable apache2
