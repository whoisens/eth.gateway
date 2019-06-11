### Install

1. [Install Docker CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
2.
 
```bash
docker network create eth-gateway

LOCAL_IP=127.0.0.1
EXTERNAL_IP=51.89.37.142

# Geth stable
PORT=30303
mkdir -p /data/node-geth-stable-mainnet
docker run -d --name node-geth-stable-mainnet --net eth-gateway -v /data/node-geth-stable-mainnet:/root \
           -p ${LOCAL_IP}:${PORT}:${PORT} -p ${LOCAL_IP}:${PORT}:${PORT}/udp \
           ethereum/client-go:stable --syncmode "fast" --cache=4096 --rpc --rpcaddr 0.0.0.0 --rpcvhosts=* --rpcapi="eth,net,web3" --rpccorsdomain=* \
           --maxpeers=256 --maxpendpeers=3 --nat extip:${EXTERNAL_IP}

# Parity
PORT=30313
mkdir -p /data/node-parity-stable-mainnet
docker run -d --name node-parity-stable-mainnet --net eth-gateway \
       -v /data/node-parity-stable-mainnet:/home/parity/.local/share/io.parity.ethereum \
       -p ${LOCAL_IP}:${PORT}:${PORT} -p ${LOCAL_IP}:${PORT}:${PORT}/udp parity/parity:stable \
       --port=${PORT} \
       --base-path /home/parity/.local/share/io.parity.ethereum --no-ipc --jsonrpc-apis="eth,rpc,net,web3" \
       --jsonrpc-interface all --jsonrpc-hosts="all" --jsonrpc-cors="all" --cache-size 4096 \
       --jsonrpc-max-payload=1 --db-compaction=ssd --mode=active --max-peers=256 --min-peers=50 --max-pending-peers=256 \
       --no-hardware-wallets --nat extip:${EXTERNAL_IP}

# Geth unstable
PORT=30323
mkdir -p /data/node-geth-unstable-mainnet
docker run -d --name node-geth-unstable-mainnet --net eth-gateway -v /data/node-geth-unstable-mainnet:/root \
           -p ${LOCAL_IP}:${PORT}:${PORT} -p ${LOCAL_IP}:${PORT}:${PORT}/udp \
           ethereum/client-go --syncmode "fast" --cache=4096 --rpc --rpcaddr 0.0.0.0 --rpcvhosts=* --rpcapi="eth,net,web3" --rpccorsdomain=* \
           --maxpeers=256 --maxpendpeers=3 --port=${PORT} --nat extip:${EXTERNAL_IP}

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
