import hre, { ethers } from "hardhat";

import { getAccounts } from "@/utils/account.util";
import addressUtil from "@/utils/address.util";

async function main() {
  // TODO: add deploy code here
  const [admin] = getAccounts(hre.network.name);

  const Renthings = await ethers.getContractFactory("Renthings");

  const rth = addressUtil.getAddress("RTH", hre.network.name) || "";

  const renthings = await Renthings.deploy(rth);
  await renthings.deployed();

  console.log("Deployed Renthings to: ", renthings.address);

  addressUtil.setAddress("Renthings", renthings.address, hre.network.name);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
