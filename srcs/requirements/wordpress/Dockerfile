FROM debian:buster
RUN apt update -y && apt upgrade -y && \
	apt install -y wget php7.3 php-fpm php-mysql mariadb-client && \
	wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www && \
	cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz && \
	chown -R root:root /var/www/wordpress

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

COPY conf/wordpress.sh /bin/wordpress.sh
RUN chmod +x /bin/wordpress.sh
CMD ["/bin/wordpress.sh"]
