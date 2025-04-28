FROM debian:buster
RUN apt update -y && apt upgrade -y
RUN apt install -y curl vim zsh git wget mariadb-server
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" --unattended
# CMD ["zsh"]

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/mariadb.sh /bin/mariadb.sh
RUN chmod +x /bin/mariadb.sh
ENTRYPOINT ["/bin/mariadb.sh"]