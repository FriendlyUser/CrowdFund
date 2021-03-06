require('dotenv').config();
const HDWalletProvider = require('truffle-hdwallet-provider');

const mnemonic = process.env.MNEMONIC
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/" + process.env.INFURA_API_KEY),
      network_id: 3
      //gas: 4000000,
      //gasPrice: 28921116127
    },
    rinkeby: {
      provider: new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/" + process.env.INFURA_API_KEY),
      network_id: 4
      //gas: 6000000,
      //gasPrice: 28921116127
    },
    kovan: {
      provider: new HDWalletProvider(mnemonic, "https://kovan.infura.io/v3/" + process.env.INFURA_API_KEY),
      network_id: 42
      //gas: 4612388,
      //gasPrice: 28921116127
    },
    coverage: {
      host: "localhost",
      network_id: "*",
      port: 8555,         // <-- If you change this, also set the port option in .solcover.js.
      gas: 0xfffffffffff, // <-- Use this high gas value
      gasPrice: 0x01      // <-- Use this low gas price
    },
   }
}