import hre, { ethers } from "hardhat";

import { getAccounts } from "@/utils/account.util";

async function main() {
  // TODO: add deploy code here
  const addresses = getAccounts(hre.network.name);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
