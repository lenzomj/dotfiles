#!/usr/bin/env bash

wget http://dodpki.c3pki.chamb.disa.mil/rel3_dodroot_2048.p7b
mkdir -p $HOME/.ssh
openssl pkcs7 -inform DER -outform PEM -in rel3_dodroot_2048.p7b \
     -print_certs > $HOME/.ssh/rel3_dodroot_2048.crt
