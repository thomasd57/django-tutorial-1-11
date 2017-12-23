This repo contains 
a) django 'polls' tutorial 
b) Dockerfiles to build docker image to run server to serve the application

Dockerfiles are split in two, because it is anticipated that the first one will not be changing

The base docker file docker-azure/Dockerfile installs sshd, so that it is possible to ssh to a running container.

1. create azure docker image:
> docker build -f Dockerfile.azure -t azure .

2. create server docker image
> docker build -t polls .

3. decrypt secrets file and ssh key
> gpg secrets.env.gpg
> gpg docker-azure/id_rsa
> chmod 600 docker-azure/id_rsa

4. run server in the docker container
> docker run --env-file secrets.env -p 8000:80 -p 2222:22 polls

5. You can ssh into the container
> ssh -p 2222 -i docker-azure/id_rsa root@127.0.0.1

Make sure to adjust firewall rules if you want to ssh from a remote machine
