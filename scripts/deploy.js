const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const TownsFactory  = await hre.ethers.getContractFactory("Towns");
  const towns  = await TownsFactory.deploy();
  await towns.waitForDeployment();
  const townAddress = await towns.getAddress();
  console.log("towns contract deployed to:", townAddress);

  const TownMapFactory = await hre.ethers.getContractFactory("TownMaps");
  const townMap = await TownMapFactory.deploy(townAddress);
  await townMap.waitForDeployment();
  console.log("townMap deployed to:", await townMap.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
