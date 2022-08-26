import hre, { ethers } from "hardhat";

// import { getAccounts } from "@/utils/account.util";
import addressUtil from "@/utils/address.util";

import { IERC20__factory } from "../../typechain-types";

async function main() {
  // TODO: add deploy code here
  // const [admin] = getAccounts(hre.network.name);
  const [adminSigner] = await ethers.getSigners();

  console.log(addressUtil.getAddress("RTH", hre.network.name));

  const rth = IERC20__factory.connect(
    addressUtil.getAddress("RTH", hre.network.name) || "",
    adminSigner
  );

  console.log(adminSigner.address);

  const balance = await rth.balanceOf(adminSigner.address);
  console.log(`RTH Balance of ${adminSigner.address}: `, balance);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
