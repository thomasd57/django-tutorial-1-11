# Introduction

This repository contains django _polls_ tutorial, developed with django 1.11, to be used on Microsoft Azure

1. Database is configured to use Azure SQL
2. Deployment to Azure is achieved with docker using Azure Container Instances and Azure Container Registry.
3. Docker is configured for remote SSH access using ssh keys.
4. Application is started with gunicorn, running behind nginx front-end. Nginx terminates SSL.

# Workflow

1. You should have an Azure account and set up Azure SQL database, this is outside of this tutorial.
2. Prepare a file secrets.env with the following settings:
```
RDS_NAME=<name of the database>
RDS_USE=<userid to log in the database>
RDS_PASSWORD=<database password>
RDS_HOST=<host name for the database>
```
Check the file `django_tutorial/settings.py` how these variables are used. 

3. Set python virtual environment and the environment variables listed in point 2. to verify that the server works 
correctly locally. The database will be empty, you can use admin interface to add a quiz.
```
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
manage.py migrate
manage.py runserver 0:8000
```
Point the browser to http://127.0.0.1:8000.

4. Verify that server works locally using _production_ mode, i.e. starting django app via wsgi.py and gunicorn. You will need to first collect statics
```
manage.py collectstatic
run-server.sh
```
Point the browser to http://127.0.0.1:8000. Any database changes you did in step 3. should still work.

5. Prepare SSH and SSL keys for logging into docker container.
```
gen-keys.sh
```
5. Create base _polls-base_ django container
```
docker build -t polls-base polls-base
```
6. Build the final docker image. We are splitting docker images into two, because the second one (polls) would be 
rebult with any change to your application code. The first (polls-base) is generic.
```
docker build -t polls .
```
7. Run the docker image locally and check that you can ssh to it:
```
docker-run.ssh
ssh -i polls-base/id_rsa -p 2222 root@127.0.0.1
```
Point the browser to http://127.0.0.1 to verify that it works.

8. Push the image to Azure Container Registry and run container. You will need first to create Azure Container Registry.
```
az-container-create.sh
```
9. You can now ssh into container on Azure, after it was created.
```
az container list -o table # Check if the container is created and find IP address
ssh -i polls-base/keys/id_rsa root@<ipaddress>
```
10. Verify that the container works, by pointing the browser to the container IP.
