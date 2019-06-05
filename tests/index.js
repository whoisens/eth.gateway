import util from 'util';
import {exec} from 'child_process';
import Suite from 'node-test';
import nodes from '../docker-files/nodes.json';

const execCommand = util.promisify(exec);

for (const node of nodes) {
  const nodeURLs = node.urls;

  for (const nodeURL of nodeURLs) {
    const suite = new Suite(`${node.name} - ${nodeURL}`);
    suite.test('Node has been synced', async (t) => {
      const {stdout, stderr} = await execCommand(`geth --exec "eth.syncing" attach ${nodeURL}`);

      t.falsey(stderr);
      t.equal(stdout.trim(), "false");
    });

    suite.test('Check for correct node version/identification', async (t) => {
      const {stdout, stderr} = await execCommand(`geth --exec "web3.version.node" attach ${nodeURL}`);

      t.falsey(stderr);
      t.truthy(stdout.trim().includes(node.id));
    });

    suite.test('Check ability to call RPC with curl', async (t) => {
      const {stdout, stderr} = await execCommand(`curl -s --data '{"method":"eth_syncing","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST ${nodeURL}`);

      t.falsey(stderr);
      const result = JSON.parse(stdout);
      t.equal(result.result, false);
    });
  }
}
