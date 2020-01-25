#!/bin/bash
yum install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb
mysql -u root -p
CREATE USER 'root'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
