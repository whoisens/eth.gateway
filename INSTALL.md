### Install

1. [Install Docker CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
2.
 
```bash
docker network create eth-gateway

# Geth stable
mkdir -p /data/node-geth-stable-mainnet
docker run -d --name node-geth-stable-mainnet --net eth-gateway -v /data/node-geth-stable-mainnet:/root \
           -p 30303:30303 -p 30303:30303/udp \
           ethereum/client-go:stable --syncmode "fast" --cache=4096 --rpc --rpcaddr 0.0.0.0 --rpcvhosts=* --rpcapi="eth,net,web3" --rpccorsdomain=* \
           --maxpeers=256 --maxpendpeers=3

# Parity
mkdir -p /data/node-parity-stable-mainnet
docker run -d --name node-parity-stable-mainnet --net eth-gateway \
       -v /data/node-parity-stable-mainnet:/home/parity/.local/share/io.parity.ethereum \
       -p 30313:30313 -p 30313:30313/udp parity/parity:stable \
       --port=30313 \
       --base-path /home/parity/.local/share/io.parity.ethereum --no-ipc --jsonrpc-apis="eth,rpc,net,web3" \
       --jsonrpc-interface all --jsonrpc-hosts="all" --jsonrpc-cors="all" --cache-size 4096 \
       --jsonrpc-max-payload=1 --db-compaction=ssd --mode=active --max-peers=256 --min-peers=50 --max-pending-peers=256 \
       --no-hardware-wallets

# Geth unstable
mkdir -p /data/node-geth-unstable-mainnet
docker run -d --name node-geth-unstable-mainnet --net eth-gateway -v /data/node-geth-unstable-mainnet:/root \
           -p 30323:30323 -p 30323:30323/udp \
           ethereum/client-go --syncmode "fast" --cache=4096 --rpc --rpcaddr 0.0.0.0 --rpcvhosts=* --rpcapi="eth,net,web3" --rpccorsdomain=* \
           --maxpeers=256 --maxpendpeers=3

docker build . -t whoisens-eth-gateway

# please see env/README.md
docker run -d --net eth-gateway -p 80:80 -p 443:443 --name whoisens-eth-gateway whoisens-eth-gateway
```

From other machine:

```bash
geth attach http://eth.gateway.whoisens.org
> eth.syncing.currentBlock / eth.syncing.highestBlock

geth attach https://eth.gateway.whoisens.org
> eth.syncing.currentBlock / eth.syncing.highestBlock
```

or

```bash
curl --data '{"method":"eth_syncing","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST https://eth.gateway.whoisens.org
```
