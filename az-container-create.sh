#!/bin/bash

image_name=${1:?Usage: $0 IMAGE [CONTAINER]}
container_name=${2:-$image_name}

# Read environment variables
vars=( $(cat secrets.env) )

# get the registry password
password=$(az acr credential show -n AmpervueContainers --query 'passwords[0].value' | sed -e 's/"//g')
resource_group=$(az acr list --query '[0].resourceGroup' | sed -e 's/"//g')
registry=$(az acr list --query '[0].name' | sed -e 's/"//g' | tr A-Z a-z)
login_server=$(az acr list --query '[0].loginServer' | sed -e 's/"//g')
az acr login --name $registry
# This is required only once, but is fast, so we do it all the time
az acr update --name $registry --admin-enabled true

# Using tag to guarantee that this replaces any existing container
# Right now Azure doesn't replace the container generated from the same image.
# RANDOM is there to be able to use same git hash (with local changes)
tag=$(git rev-parse --short HEAD)-$((RANDOM % 100))
docker tag $image_name $registry.azurecr.io/$image_name:$tag
docker push $registry.azurecr.io/$image_name:$tag
set -x
az container create --name $container_name \
    --image $registry.azurecr.io/$image_name:$tag \
    --resource-group $resource_group \
    --cpu 1 \
    --environment-variables ${vars[@]} \
    --ip-address Public \
    --location westus \
    --memory 4 \
    --os-type Linux \
    --ports 80 22 443 \
    --registry-login-server $login_server \
    --registry-username $registry \
    --registry-password $password
   
