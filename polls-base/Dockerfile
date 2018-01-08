# Basic Dockerfile for Azure RDS

FROM ubuntu:16.10
# Silence warning about Readline
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y apt-utils 
RUN apt-get install -y curl apt-transport-https openssh-server nginx

# SQL server drivers
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update \
 && ACCEPT_EULA=Y apt-get install -y msodbcsql=13.1.4.0-1 unixodbc-dev
RUN apt-get install -y locales \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen

# Setup python3 and pip3 
RUN apt-get install -y python3-pip
RUN pip3 install -U pip

# SSL certificate generation
RUN apt-get install -y software-properties-common \
 && add-apt-repository -y ppa:certbot/certbot \
 && apt-get update \
 && apt-get install -y python-certbot-nginx

# SSHD config and keys
COPY sshd.conf /etc/ssh/sshd_config
WORKDIR /root
RUN mkdir .ssh && chmod 700 .ssh
COPY keys/id_rsa.pub .ssh/authorized_keys

EXPOSE 22

# Nginx config and keys
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-gunicorn.conf /etc/nginx/sites-enabled/default
# Development self-signed SSL certificates
COPY keys/ssl-cert-snakeoil.crt /etc/nginx/cert.crt
COPY keys/ssl-cert-snakeoil.key /etc/nginx/cert.key

EXPOSE 80
EXPOSE 443

CMD ["/bin/bash"]
