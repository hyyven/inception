#!/bin/bash
DATA_DIR="/var/lib/mysql"

mysqld_safe --datadir=$DATA_DIR --skip-networking &
for i in {30..0}; do
    if mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent; then
        break
    fi
    echo "En attente du démarrage du serveur... ($i)"
    sleep 1
done
if [ "$i" = 0 ]; then
    echo "Échec du démarrage du serveur MySQL"
    exit 1
fi

mysql --user=root <<EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';
CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'localhost';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

if [ $? -ne 0 ]; then
    echo "Erreur lors de la configuration de la base de données"
    exit 1
fi

mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
echo "Démarrage de MariaDB..."
exec mysqld_safe --datadir=$DATA_DIR
