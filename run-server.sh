#!/bin/bash

# Start gunicorn. It can be called directly or in docker, where it sits behind nginx

bind_addr=0:8000
# If we are running inside docker, start sshd and nginx
if [ -f .in_docker ]; then 
    service ssh start
    service nginx start
    bind_addr=127.0.0.1:8000
fi

# Prepare log files and start outputting logs to stdout
mkdir -p logs
touch logs/gunicorn.log
touch logs/gunicorn-access.log
tail -n 0 -f logs/gunicorn*.log &

export DJANGO_SETTINGS_MODULE=django_tutorial.settings
exec gunicorn django_tutorial.wsgi:application \
     --name django_tutorial \
     --bind $bind_addr \
     --workers 4 \
     --log-level=info \
     --log-file=logs/gunicorn.log \
     --access-logfile=logs/gunicorn-access.log \
"$@"
