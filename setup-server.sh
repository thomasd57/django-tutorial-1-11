#!/bin/sh

# This script setups server to work with Azure

apt-get update
apt-get install -y curl apt-transport-https

# SQL server drivers
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
apt-get update
ACCEPT_EULA=Y apt-get install -y msodbcsql=13.1.4.0-1 unixodbc-dev

# Setup python3 and pip3 
apt-get install -y python3-pip
update-alternatives --install /usr/bin/python python /usr/bin/python3 10
update-alternatives --install /usr/bin/pip pip /usr/bin/pip3  10

