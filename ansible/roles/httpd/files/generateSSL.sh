#!/bin/bash

FILENAME="devops-exam-ton-tiosso"
DST_PATH="/etc/httpd/ssl"

openssl \
    req \
    -x509 \
    -nodes \
    -days 365 \
    -newkey rsa:2048 \
    -subj "/C=BR/ST=SP/L=SaoPaulo/O=Tiosso LTDA/OU=IT/CN=*.devops-exam-ton-tiosso.com/emailAddress=guilherme.tiosso@gmail.com" \
    -passin pass: \
    -keyout ${DST_PATH}/${FILENAME}.key \
    -out ${DST_PATH}/${FILENAME}.crt 
