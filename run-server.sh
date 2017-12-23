#!/bin/bash

service ssh start

cd /var/app
export PYTHONPATH=/var/app:$PYTHONPATH

# Prepare log files and start outputting logs to stdout
mkdir -p /var/logs
touch /var/logs/gunicorn.log
touch /var/logs/gunicorn-access.log
tail -n 0 -f /var/logs/gunicorn*.log &

export DJANGO_SETTINGS_MODULE=django_tutorial.settings
exec gunicorn django_tutorial.wsgi:application \
     --name django_tutorial \
     --bind 0.0.0.0:80 \
     --workers 4 \
     --log-level=info \
     --log-file=/var/logs/gunicorn.log \
     --access-logfile=/var/logs/gunicorn-access.log \
"$@"
