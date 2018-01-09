#!/bin/bash -x

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
# This is required once, but is fast, so we do it all the time
az acr update --name $registry --admin-enabled true

docker tag $image_name $registry.azurecr.io/$image_name
docker push $registry.azurecr.io/$image_name
az container create --name $container_name \
    --image $registry.azurecr.io/$image_name \
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
   
