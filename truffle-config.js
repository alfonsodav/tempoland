const HDWalletProvider = require("@truffle/hdwallet-provider");

const infura_api_key = "dbdc2e2568c54847a5b7d8f66b878491";
const privateKey =
  "8ee851cb924e07a8d74a7f8d4c107108341ec879a3d8b186635ccd3e1cdb234b";

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "5777",
    },
    goerli: {
      provider: () =>
        new HDWalletProvider(
          privateKey,
          `https://goerli.infura.io/v3/${infura_api_key}`
        ),
      network_id: 5, //Goerli's id
      gas: 5000000, //gas limit
      confirmations: 1, // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200, // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true, // Skip dry run before migrations? (default: false for public nets )
    },
    dashboard: {},
  },
  compilers: {
    solc: {
      version: "^0.8.0",
    },
  },
  db: {
    enabled: false,
    host: "127.0.0.1",
  },
};
/* 

curl --url https://mainnet.infura.io/v3/dbdc2e2568c54847a5b7d8f66b878491 \
-X POST \
-H "Content-Type: application/json" \
-d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
*/
