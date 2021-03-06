#!/usr/bin/env bash
echo "Mysql installer starting..."

# Install mysql
{
    echo debconf debconf/frontend select Noninteractive
    echo mysql-community-server mysql-community-server/data-dir \
        select ''
    echo mysql-community-server mysql-community-server/root-pass \
        password ''
    echo mysql-community-server mysql-community-server/re-root-pass \
        password ''
    echo mysql-community-server mysql-community-server/remove-test-db \
        select true
} | debconf-set-selections &&
    apt-get install -y mysql-server mysql-client && rm -rf /var/lib/apt/lists/*

service mysql start

mysql -e "CREATE DATABASE laravel /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysql -e "CREATE USER 'root'@'localhost' IDENTIFIED BY '';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '';"
mysql -e "UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE User='root';"
mysql -e "FLUSH PRIVILEGES;"
