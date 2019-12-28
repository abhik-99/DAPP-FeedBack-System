const HDWalletProvider = require("truffle-hdwallet-provider");
const rpc_endpoint = "http://ethjnxov6-dns-reg1.centralus.cloudapp.azure.com:8540";
const mnemonic = "camera mother song regret edge fabric lady spy genuine remove peasant keen";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    poa: {
      provider: new HDWalletProvider(mnemonic, rpc_endpoint),
      network_id: 10101010,
      gasPrice : 0
    }
  },
  compilers: {
    solc: {
      version: "0.6.0"
    }
  }
};