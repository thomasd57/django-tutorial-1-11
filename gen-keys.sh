#!/bin/bash

# This script generates SSH and SSL keys. DOMAIN is the domain name: my.example.org

domain=${1:?Usage: gen-keys.sh DOMAIN}

# This where the keys are generated
key_dir=polls-base/keys
mkdir -p $key_dir
rm -rf $key_dir/*
# SSH
ssh-keygen -t rsa -b 4096 -N '' -f $key_dir/id_rsa
# SSL
openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout $key_dir/ssl-cert-snakeoil.key \
    -out    $key_dir/ssl-cert-snakeoil.crt \
    -subj /CN=$domain
