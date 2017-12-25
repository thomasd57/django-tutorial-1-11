#!/bin/bash

port=8000
appdir=$PWD
# If we are running inside docker, start sshd and use port 80
if [ -f .in_docker ]; then 
    service ssh start
    port=80
    appdir=/var/app
fi

cd $appdir

# Prepare log files and start outputting logs to stdout
mkdir -p logs
touch $appdir/logs/gunicorn.log
touch $appdir/logs/gunicorn-access.log
tail -n 0 -f $appdir/logs/gunicorn*.log &

export DJANGO_SETTINGS_MODULE=django_tutorial.settings
exec gunicorn django_tutorial.wsgi:application \
     --name django_tutorial \
     --bind 0:$port \
     --workers 4 \
     --log-level=info \
     --log-file=$appdir/logs/gunicorn.log \
     --access-logfile=$appdir/logs/gunicorn-access.log \
"$@"
