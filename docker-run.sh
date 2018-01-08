#!/bin/bash

# Run the docker with the appropriate options

vars=( $(cat secrets.env) )
set -x
docker run --name polls -t -p 2222:22 -p 80:80 -p 443:443 ${vars[@]/#/-e } polls
