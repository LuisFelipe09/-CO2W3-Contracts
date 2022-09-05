async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contract with the account: ", deployer.address);

  const CO2W3 = await ethers.getContractFactory("CO2W3");

  const deployed = await CO2W3.deploy();

  console.log("CO2W3 is deployed at: ", deployed.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
