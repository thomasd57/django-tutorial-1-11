# Basic Dockerfile for Azure RDS

FROM ubuntu:16.04
RUN apt-get update \
 && apt-get install -y curl apt-transport-https openssh-server

# SQL server drivers
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
 && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update \
 && ACCEPT_EULA=Y apt-get install -y msodbcsql=13.1.4.0-1 unixodbc-dev
RUN apt-get install -y locales \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
 && locale-gen

# Setup python3 and pip3 
RUN apt-get install -y python3-pip \
 && update-alternatives --install /usr/bin/python python /usr/bin/python3 10 \
 && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3  10

RUN pip3 install -U pip

EXPOSE 22

COPY sshd_config /etc/ssh/
WORKDIR /root
RUN mkdir .ssh && chmod 700 .ssh
COPY id_rsa.pub .ssh/authorized_keys

