### Install

1. [Install Docker CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
2.
 
```bash
docker network create eth-gateway

# Parity
mkdir -p /data/parity-ethereum-stable
docker run -d --net eth-gateway --name parity-ethereum-stable \
       -v /data/parity-ethereum-stable:/home/parity/.local/share/io.parity.ethereum \
       -p 127.0.0.1:8545:8545 -p 30303:30303 -p 30303:30303/udp parity/parity:stable \
       --base-path /home/parity/.local/share/io.parity.ethereum --no-ipc --jsonrpc-apis="eth,rpc,net" \
       --jsonrpc-interface all --jsonrpc-hosts="all" --jsonrpc-cors="all" --cache-size 4096 \
       --jsonrpc-max-payload=1 --db-compaction=hdd --mode=active --max-peers=512 --min-peers=50 --max-pending-peers=512 \
       --no-hardware-wallets

# or Geth stable
mkdir -p /data/ethereum-node-stable
docker run -d --name ethereum-node-stable --net eth-gateway -v /data/ethereum-node-stable:/root \
           -p 127.0.0.1:8545:8545 -p 30303:30303 -p 30303:30303/udp \
           ethereum/client-go:stable --syncmode "fast" --cache=4096 --rpc --rpcaddr 0.0.0.0 --rpcvhosts=* --rpcapi="eth,net" --rpccorsdomain=* \
           --maxpeers=256 --maxpendpeers=3

# or Geth unstable
mkdir -p /data/ethereum-node
docker run -d --name ethereum-node --net eth-gateway -v /data/ethereum-node:/root \
           -p 127.0.0.1:8545:8545 -p 30303:30303 -p 30303:30303/udp \
           ethereum/client-go --syncmode "fast" --cache=4096 --rpc --rpcaddr 0.0.0.0 --rpcvhosts=* --rpcapi="eth,net" --rpccorsdomain=*

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
