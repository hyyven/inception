FROM debian:buster
RUN apt update -y && apt upgrade -y && \
	apt install -y nginx openssl && \
	mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=afont.42.fr/UID=afont" && \
	mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /var/www/wordpress && \
	chmod 755 /var/www/wordpress && \
	chown -R www-data:www-data /var/www/wordpress
CMD [ "nginx", "-g", "daemon off;" ]