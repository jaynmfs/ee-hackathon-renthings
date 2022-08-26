import "@nomicfoundation/hardhat-toolbox";
import "tsconfig-paths/register";

import { HardhatUserConfig } from "hardhat/config";

import { getAccounts } from "./utils/account.util";

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.9",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      // TODO: append other compiler versions below
    ],
  },
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
      accounts: getAccounts("localhost"),
    },
    ropsten: {
      url: process.env.URL_ROPSTEN || "",
      accounts: getAccounts("ropsten"),
    },
    kovan: {
      url: process.env.URL_KOVAN || "",
      accounts: getAccounts("kovan"),
    },
    rinkeby: {
      url: process.env.URL_RINKEBY || "",
      accounts: getAccounts("rinkeby"),
    },
    goerli: {
      url: process.env.URL_GOERLI || "",
      accounts: getAccounts("goerli"),
    },
    bkc: {
      url: process.env.URL_BKC || "",
      accounts: getAccounts("bkc"),
    },
    bkc_testnet: {
      url: process.env.URL_BKC_TESTNET || "",
      accounts: getAccounts("bkc_testnet"),
    },
    bsc: {
      url: process.env.URL_BSC || "",
      accounts: getAccounts("bsc"),
    },
    bsc_testnet: {
      url: process.env.URL_BSC_TESTNET || "",
      accounts: getAccounts("bsc_testnet"),
    },
    fin_testnet: {
      url: process.env.URL_FIN_TESTNET || "",
      accounts: getAccounts("fin_testnet"),
    },
    // TODO: append other chain below
  },
  gasReporter: {
    enabled: process.env.GAS_REPORT === "true",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY || "",
  },
};

export default config;
