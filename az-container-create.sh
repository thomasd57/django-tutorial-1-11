#!/bin/bash -x

registry=${1:?Usage: az-container-create.sh <registry> <resource_group>}
resource_group=${2:?Usage: az-container-create.sh <registry> <resource_group>}

az acr login --name $registry
az acr update --name $registry --admin-enabled true

docker push $registry.azurecr.io/polls

# put all env variables on a single line
vars="$(sed -e :a -e '$!N; s/\n/ /; ta' secrets.env)"

# get the registry password
password=$(az acr credential show -n $registry -o table | awk "\$1 == $registry { print \$2; }")
login_server=$(az acr list -o table | awk "\$1 == $registry { print \$5; }")

az container create --name polls \
    --image $registry.azurecr.io/ampervue-polls \
    --resource-group $resource_group \
    --cpu 1 \
    --environment-variables $vars \
    --ip-address Public \
    --location westus \
    --memory 4 \
    --os-type Linux \
    --ports 80 22 \
    --registry-login-server $login_server \
    --registry-username AmpervueContainers \
    --registry-password $password
   
