# Umbrel %btc-provider node 

This image is a port of the self-contained [%btc-provider](https://github.com/wexpertsystems/urbit-bitcoin-node) image which acts as a backend for Urbit's Bitcoin wallet. This port is an app for [Umbrel](https://getumbrel.com/), a personal server project focused on crypto sovereignty.

Since Umbrel ships with `bitcoind` and `electrs` out of the box, the only remaining component from the original stack is a custom Express proxy that translates `electrs`'s RPC calls from TCP to HTTP. As a result it is quite lightweight, but entirely dependent on the host's services.

The Docker Compose file is included for reference. Most importantly it imports env vars that describe the `bitcoind` and `electrs` servers to communicate with. This package does not need persistent storage.

### Installation

Make a file on your umbrel called `/home/umbrel/apps/urbit-btc-node/docker-compose.yml`

Paste the following into it:

```
version: "3.7"

services:
  web:
    image: matwet/urbit-btc-node:staging
    restart: on-failure
    stop_grace_period: 1m
    ports:
      - 50002:50002
    environment:
      $ELECTRUM_IP: $ELECTRUM_IP
      $ELECTRUM_PORT: $ELECTRUM_PORT
      $BITCOIN_IP: $BITCOIN_IP
      $BITCOIN_RPC_PORT: $BITCOIN_RPC_PORT
      $BITCOIN_RPC_USER: $BITCOIN_RPC_USER
      $BITCOIN_RPC_PASS: $BITCOIN_RPC_PASS
      $BITCOIN_RPC_AUTH: $BITCOIN_RPC_AUTH
```

then: 

```
$> run ~/scripts/app install urbit-btc-node
```
On a fully synced Umbrel, you can connect your ship to it like this:

```
dojo> |rein %bitcoin [& %btc-provider]
dojo> =network %main
dojo> :btc-provider +bitcoin!btc-provider/command [%set-credentials api-url='http://addresshere:50002' network]
```

If it's working, you will be able to see a new block announcement in your dojo.
