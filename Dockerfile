FROM ubuntu:18.04

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y nginx nano

RUN mkdir /etc/ssl
RUN chmod 700 /etc/ssl

COPY docker-files/certs/server.crt /etc/ssl/certs/server.crt
COPY docker-files/certs/server.key /etc/ssl/private/server.key
COPY docker-files/certs/ca-bundle.crt /etc/ssl/ca-bundle.crt

RUN chmod 400 /etc/ssl/*

COPY docker-files/nodes.json /var/www/html/
COPY docker-files/index.html /var/www/html/

COPY docker-files/default /etc/nginx/sites-available/

ENTRYPOINT nginx -g 'daemon off;'
