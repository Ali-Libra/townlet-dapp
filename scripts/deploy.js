const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const ContractFactory = await hre.ethers.getContractFactory("Towns");
  const contract = await ContractFactory.deploy();

  // v6 部署后，等待交易确认要用 contract.deploymentTransaction().wait()
  await contract.deploymentTransaction().wait();

  console.log("deployed to:", contract.target);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
