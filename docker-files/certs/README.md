```bash
openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr
```

After you have certificates, 

```bash
cat server.crt ca-bundle.crt > fullchain.crt
```
