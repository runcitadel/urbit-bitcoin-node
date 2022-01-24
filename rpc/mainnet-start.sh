#!/bin/bash
##########################
# Set host.docker.internal
sudo /usr/bin/append-to-hosts "$(ip -4 route list match 0/0 | awk '{print $3 "\thost.docker.internal"}')"
echo Running modified mainnet script...
# docker-compose.yml passes the folllowing env vars:
# $BITCOIN_RPC_AUTH, $BITCOIN_PORT, $BITCOIN_IP, $BITCOIN_PORT,
# $ELECTRUM_IP, and $ELECTRUM_PORT
export PROXY_PORT=50002

node src/server.js
