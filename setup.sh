#!/bin/bash

function createCert {
    NAME_PREFIX=$1
    openssl req -newkey rsa:2048 -nodes -keyout $NAME_PREFIX.key -x509 -days 365 -out $NAME_PREFIX.cer 
}

function addToEnv {
    echo "$1" >> .env
}

CERT_DIR=/etc/ssl/certs
DOMAIN=eid.de
IP4_PREFIX=$(hostname -I | cut -d' ' -f 1 | cut -d. -f 1,2)

echo :Remove existing setup files
rm .env {www,MAIN}.{cer,key} > /dev/null

echo :Shutdown the system if running
sudo docker-compose down
sudo docker volume rm eidfuswp_db_mysql

echo :Create .env file
addToEnv "BOILERPLATE_DOMAIN=$DOMAIN"
addToEnv "BOILERPLATE_IPV4_16PREFIX=$IP4_PREFIX"
addToEnv "BOILERPLATE_IPV6_SUBNET=bade:affe:dead:beef:b011::/80"
addToEnv "BOILERPLATE_IPV6_ADDRESS=bade:affe:dead:beef:b011:0642:ac10:0080"
addToEnv "BOILERPLATE_WWW_CERTS=$CERT_DIR"
addToEnv "BOILERPLATE_API_SECRETKEY=$(date | md5sum | cut -d' ' -f 1)"
sleep 1
addToEnv "BOILERPLATE_DB_PASSWORD=$(date | md5sum | cut -d' ' -f 1)"

echo "#################### .env ####################"
cat .env
echo "##############################################"
echo "Make sure the line '$IP4_PREFIX.0.128<tab>$DOMAIN' is in you /etc/hosts"


echo :Create ssl certifactes
createCert MAIN
createCert www

sudo mv {MAIN,www}.{cer,key} "$CERT_DIR/"
sudo chown root:root $CERT_DIR/{MAIN,www}.{cer,key}

echo :Start compose
sudo docker-compose up --build

