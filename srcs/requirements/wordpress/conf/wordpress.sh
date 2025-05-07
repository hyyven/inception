#!/bin/bash

mkdir -p /run/php

cd /var/www/wordpress

echo "En attente de la disponibilité de MariaDB..."
while ! mysqladmin ping -h mariadb -u ${SQL_USER} -p${SQL_PASSWORD} --silent; do
    echo "MariaDB n'est pas encore prêt... nouvelle tentative dans 1 seconde"
    sleep 1
done
echo "MariaDB est prêt, configuration de WordPress..."

if [ ! -f /var/www/wordpress/wp-config.php ]; then
	wp config create --allow-root \
		--dbname=$SQL_DATABASE \
		--dbuser=$SQL_USER \
		--dbpass=$SQL_PASSWORD \
		--dbhost=mariadb:3306 --path='/var/www/wordpress'
fi

if ! wp core is-installed --allow-root; then
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root
fi

exec /usr/sbin/php-fpm7.3 -F