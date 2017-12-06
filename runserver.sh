#!/bin/bash

cd /var/app
export PYTHONPATH=/var/app:$PYTHONPATH

gunicorn -b 0:8000 django_tutorial.wsgi
