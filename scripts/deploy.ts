const { ethers } = require('hardhat');

async function main() {  

  const GreenTokens = await ethers.getContractFactory("GreenTokens");
  const lock = await GreenTokens.deploy();

  await lock.deployed();

  console.log(`GreenTokens deployed to ${lock.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
