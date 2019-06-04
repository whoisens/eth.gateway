# Ethereum Node

> Service used by [WhoisENS.org](https://whoisens.org)

**Endpoint**: [https://eth.gateway.whoisens.org](https://eth.gateway.whoisens.org)


### How to use

You can use any third-party library as usual to connect to Ethereum node.
There's example of using Web3.js.

```javascript
import Web3 from 'web3';

const networkURL = 'https://eth.gateway.whoisens.org';
const name = 'whoisens.eth';

(async () => {
  const web3 = new Web3(Web3.givenProvider || networkURL);

  const forwardResolve = await web3.eth.ens.getAddress(name);
  console.log('Forward Resolve', forwardResolve);

  const contentHash = await web3.eth.ens.getContenthash(name);
  console.log('Content hash', contentHash);
})();
```

### Install

You can install your own instance of that node. Please see [INSTALL.md](./INSTALL.md)
