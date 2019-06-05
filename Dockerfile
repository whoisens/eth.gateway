FROM ubuntu:18.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get install -y software-properties-common

RUN add-apt-repository -y ppa:ondrej/apache2 && \
    apt-get update && \
    apt-get install -y apache2

RUN a2enmod ssl vhost_alias http2 headers rewrite socache_shmcb proxy proxy_http

COPY docker-files/000-default.conf /etc/apache2/sites-enabled/
COPY docker-files/certs/server.crt /etc/ssl/certs/server.crt
COPY docker-files/certs/server.key /etc/ssl/private/server.key
COPY docker-files/certs/ca-bundle.crt /etc/apache2/ssl.crt/ca-bundle.crt

COPY docker-files/nodes.json /var/www/html/

EXPOSE 80 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
