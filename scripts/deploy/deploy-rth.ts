import hre, { ethers } from "hardhat";

import { getAccounts } from "@/utils/account.util";
import addressUtil from "@/utils/address.util";

async function main() {
  // TODO: add deploy code here
  // const [admin] = getAccounts(hre.network.name);

  const RTH = await ethers.getContractFactory("RTH");

  const rth = await RTH.deploy(ethers.utils.parseEther("20000000"));
  await rth.deployed();

  console.log("Deployed RTH to: ", rth.address);

  addressUtil.setAddress("RTH", rth.address, hre.network.name);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
