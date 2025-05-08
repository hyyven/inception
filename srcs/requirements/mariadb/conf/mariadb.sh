#!/bin/bash
DATA_DIR="/var/lib/mysql"
DB_INITIALIZED="/var/lib/mysql/db_initialized"

mysqld_safe --datadir=$DATA_DIR --skip-networking &
for i in {30..0}; do
    if mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; then
        break
    fi
    echo "Waiting for server startup... ($i)"
    sleep 1
done
if [ "$i" = 0 ]; then
    echo "MySQL server startup failed"
    exit 1
fi

if [ ! -f "$DB_INITIALIZED" ]; then
    echo "First database initialization..."
    mysql --user=root <<EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'localhost';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    
    if [ $? -eq 0 ]; then
        echo "Database initialized successfully."
        touch "$DB_INITIALIZED"
    else
        echo "Error during database configuration"
        exit 1
    fi
else
    echo "Database already initialized, using existing settings."
fi

mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown || echo "Error shutting down server, attempting to continue..."

echo "Starting MariaDB"
exec mysqld_safe --datadir=$DATA_DIR
