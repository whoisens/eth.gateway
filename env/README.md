# Environment setup


### First run

```bash
docker run -d --net eth-gateway -p 127.0.0.5:80:80 -p 127.0.0.5:443:443 --name whoisens-eth-gateway whoisens-eth-gateway
```


**/etc/rc.local**

```bash
sysctl -w net.ipv4.conf.all.route_localnet=1

# api
iptables -t nat -I PREROUTING -d 185.244.128.122 -p tcp --dport 80 -j DNAT --to 127.0.0.5:80
iptables -t nat -I PREROUTING -d 185.244.128.122 -p tcp --dport 443 -j DNAT --to 127.0.0.5:443

docker start whoisens-eth-gateway
```


```bash
systemctl start rc-local
```
