FROM debian:buster

RUN apt update -y && \
	apt upgrade -y && \
	apt install -y mariadb-server procps

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod 644 /etc/mysql/mariadb.conf.d/50-server.cnf && \
	chown mysql:mysql /etc/mysql/mariadb.conf.d/50-server.cnf

COPY conf/mariadb.sh /bin/mariadb.sh
RUN chmod +x /bin/mariadb.sh
ENTRYPOINT ["/bin/mariadb.sh"]