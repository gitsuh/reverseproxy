#!/bin/bash

if [ ! -f .env ]; then
    
	if [ -z "$1" ]; then
	    echo -e "\nPlease supply FQDN '$0 <fqdn> <password for neo4j>' to run the bootstrap script.\n"
	    exit 1
	fi

	if [ -z "$2" ]; then
	    echo -e "\nPlease supply password '$0 <fqdn> <password for neo4j>' to run the bootstrap script.\n"
	    exit 1
	fi

	echo "HOSTNAME=$1" > .env
	echo "PASSWORD=$2" >> .env
fi



SUBJECT="/C=US/ST=New_York_City/L=New_York/O=Docker/OU=Docker/CN="$HOSTNAME
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj $SUBJECT \
    -keyout $HOSTNAME.key  -out $HOSTNAME.crt

cp $HOSTNAME.key cert.key
cp $HOSTNAME.crt cert.crt

sudo docker build -t reverseproxy .
sudo docker-compose up -d

TARGET="$(sudo docker ps -a | grep "reverseproxy" | awk {' print $1 '} )"
echo $TARGET
sudo docker logs $TARGET
echo "sudo docker logs $TARGET"



