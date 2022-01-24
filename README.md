# Umbrel %btc-provider node 

This image is a port of the self-contained [%btc-provider](https://github.com/wexpertsystems/urbit-bitcoin-node) image which acts as a backend for Urbit's Bitcoin wallet. This port is an app for [Umbrel](https://getumbrel.com/), a personal server project focused on crypto sovereignty.

Since Umbrel ships with `bitcoind` and `electrs` out of the box, the only remaining component from the original stack is a custom Express proxy that translates `electrs`'s RPC calls from TCP to HTTP. As a result it is quite lightweight, but entirely dependent on the host's services.

The Docker Compose file is included for reference. Most importantly it imports env vars that describe the `bitcoind` and `electrs` servers to communicate with. This package does not need persistent storage.

Once running on a fully synced Umbrel, you can connect your ship to it like this:

```
dojo> |rein %bitcoin [& %btc-provider]
dojo> =network %main
dojo> :btc-provider +bitcoin!btc-provider/command [%set-credentials api-url='http://addresshere:50002' network]
```

If it's working, you will be able to see a new block announcement in your dojo.
