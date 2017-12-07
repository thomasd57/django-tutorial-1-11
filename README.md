This repo contains 
a) django 'polls' tutorial 
b) Dockerfiles to build docker image to run server to serve the application

Dockerfiles are split in two, because it is anticipated that the first one will not be changing

1. create azure docker image:
> docker build -f Dockerfile.azure -t azure .

2. create server docker image
> docker build -t server .

3. decrypt secrets file
> gpg secrets.env.gpg

4. run server in the docker container
> docker docker run --env-file secrets.env -p 8000:8000 -it server
