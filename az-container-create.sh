#!/bin/bash

# put all env variables on a single line
vars="$(sed -e :a -e '$!N; s/\n/ /; ta' secrets.env)"

# get the registry password
password=$(az acr credential show -n AmpervueContainers -o table | awk '$1 == "AmpervueContainers" { print $2; }')
echo "password=$password"
login_server=$(az acr list -o table | awk '$1 == "AmpervueContainers" { print $5; }')
echo "login_server=$login_server"

docker tag polls ampervuecontainers.azurecr.io/ampervue-polls

az container create --name polls \
    --image ampervuecontainers.azurecr.io/ampervue-polls \
    --resource-group AmpervueResourceGroup \
    --cpu 1 \
    --environment-variables $vars \
    --ip-address Public \
    --location westus \
    --memory 4 \
    --os-type Linux \
    --ports 80 \
    --registry-login-server $login_server \
    --registry-username AmpervueContainers \
    --registry-password $password
   
