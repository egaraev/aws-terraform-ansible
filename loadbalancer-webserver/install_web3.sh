#!/bin/bash
yum install -y httpd
systemctl start httpd
chkconfig httpd on
echo "<html><h1>WEB SERVER 3</h2></html>" > /var/www/html/index.html