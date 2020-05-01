#!/bin/bash
yum install -y httpd
systemctl start httpd
chkconfig httpd on
echo "$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" > /var/www/html/index.html