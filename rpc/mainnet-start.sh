#!/bin/bash
##########################
# Set host.docker.internal
#sudo /usr/bin/append-to-hosts "$(ip -4 route list match 0/0 | awk '{print $3 "\thost.docker.internal"}')"
echo Running modified mainnet script...
# docker-compose.yml passes the folllowing env vars:
# $BITCOIN_RPC_AUTH, $BITCOIN_PORT, $BITCOIN_IP, $BITCOIN_PORT,
# $ELECTRUM_IP, and $ELECTRUM_PORT
export PROXY_PORT=55555
export BITCOIN_RPC_PORT=$BITCOIN_RPC_PORT
export BITCOIN_IP=$BITCOIN_IP
export ELECTRUM_IP=$ELECTRUM_IP
export ELECTRUM_PORT=$ELECTRUM_PORT
export BITCOIN_RPC_AUTH=$BITCOIN_RPC_AUTH
export BITCOIN_RPC_PASS=$BITCOIN_RPC_PASS
export INTERNAL_IP=$INTERNAL_IP

if [ -z "${INTERNAL_IP}"  ]
then
    cp index.html /index/index.html
    sed -i "s/local.ip.address.here/${INTERNAL_IP}/g" /index/index.html
fi

nginx -c /etc/nginx/conf.d/nginx.conf
node src/server.js >> /proc/1/fd/1
