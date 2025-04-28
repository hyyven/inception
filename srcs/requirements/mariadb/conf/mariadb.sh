#!/bin/bash

if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then
    mysqld_safe --datadir=/var/lib/mysql &
    until mysqladmin ping --silent; do
        sleep 1
    done
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
    mysql -e "FLUSH PRIVILEGES;"
    mysqladmin -u root -p $SQL_ROOT_PASSWORD shutdown
fi

exec mysqld_safe --datadir=/var/lib/mysql
