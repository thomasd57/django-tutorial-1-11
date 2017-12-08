# Introduction
This document describes steps to deploy docker containers into Azure Container Service

# Initial Steps
This steps have to be done once, to create ACR (Azure Container Registry)

## Create resource group`
`> az group create --name CompanyResourceGroup --location westus`

## Create Azure Container Registry (acr)
`> az acr create --resource-group CompanyResourceGroup --name CompanyContainers --sku Standard`

## Login to ACR instance
`> az acr login --name CompanyContainers`

## Turn on admin login
`> az acr update -n CompanyContainers --admin-enabled true`

## find login server name
> az acr list --resource-group CompanyResourceGroup  --query "[].{acrLoginServer:loginServer}" --output table

## find your password
`> az acr credential show -n CompanyContainers -o table`

# These steps are to be when you update the image

## Pull docker image from your repo as usual,
`> docker pull my_repo/my_app`

## tag docker image for the push
`> docker tag server companycontainers.azurecr.io/my_app`

## push docker image to ACR
`> docker push companycontainers.azurecr.io/my_app`

## list images in the repository
`> az acr repository list --name CompanyContainers  --output table`

## see tags for a specific image
`> az acr repository show-tags --name CompanyContainers  --repository ampervue-server  --output table`

## Deploy the container
1. Collect all environment variables in `vars`, as space separated `name=value`
2. put your password from `az acr credential step` in `password`

`> az container create --name my_app \
    --image companycontainers.azurecr.io/my_app \
    --resource-group CompanyResourceGroup \
    --cpu 1 \
    --environment-variables $vars \
    --ip-address Public \
    --location westus \
    --memory 4 \
    --os-type Linux \
    --ports 80 \
    --registry-login-server companycontainers.azurecr.io \
    --registry-username CompanyContainers \
    --registry-password $password`
   
