import * as dotenv from "dotenv";
import fs from "fs";
import path from "path";

export const getAccounts = (network = "hardhat") => {
  const targetEnvPath = path.join(__dirname, `../.env.${network}`);
  const targetEnvExist = fs.existsSync(targetEnvPath);
  const envPath = targetEnvExist
    ? targetEnvPath
    : path.join(__dirname, `../.env`);

  dotenv.config({
    path: envPath,
  });
  const arr = Object.entries(process.env);
  const privateKeys = arr
    .filter(([key]) => key.startsWith("PRIVATE_KEY"))
    .map(([, value]) => value || "")
    .filter((value) => value !== "");

  return privateKeys;
};

export default {
  getAccounts,
};
