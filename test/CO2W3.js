const { expect } = require("chai");
const { ethers } = require("hardhat");

describe('CO2W3 Contract', () => {

  const setup = async () => {
    const [owner] = await ethers.getSigners();
    const CO2W3 = await ethers.getContractFactory("CO2W3");
    const deployed = await CO2W3.deploy();

    return {
      owner,
      deployed
    }
  }

  describe('Creating new Project', () => {
    it('Validate the maxSupply of a new Project', async () => {
      const { owner, deployed } = await setup({});
      await deployed.createCharcoalProject(123, 10, "hola");
      const maxSuppplyNewProject = await deployed.projectMaxSupply(0);
      expect(maxSuppplyNewProject).to.equal(10);
    })

    it('Validate the erros of create a new Project', async () => {
      const { owner, deployed } = await setup({});
      await expect(deployed.createCharcoalProject(0, 0, "")).to.be.revertedWith("Is necesary an identificator of project");
    })

    it('Validate the MetaData of a new Project', async () => {
      const { owner, deployed } = await setup({});
      await deployed.createCharcoalProject(123, 10, "hola");
      const metaDataNewProject = await deployed.projectMetaData(0);
      expect(metaDataNewProject).to.equal("hola");
    })

    it('Validate the quantity of a Projects', async () => {
      const { owner, deployed } = await setup({});
      await deployed.createCharcoalProject(123, 10, "hola");
      const totalProjectSupply = await deployed.totalProjectSupply();
      expect(totalProjectSupply).to.equal(1);
    })
  });

  describe('Minting', () => {
    it('Validate the metadata of New NFT', async () => {
      const { deployed } = await setup({});
      await deployed.createCharcoalProject(123, 10, "hola");
      await deployed.mint(0, 123);
      const tokenURI = await deployed.tokenURI(0);
      expect(tokenURI).to.equal("hola");
    })

    it('Validate error when companyId is not correct', async () => {
      const { deployed } = await setup({});
      await deployed.createCharcoalProject(123, 10, "hola");
      await expect(deployed.mint(0, 0)).to.be.revertedWith("That project doesn't exists");
    })

    it('Validate error when maxSupply is full', async () => {
      const { deployed } = await setup({});
      await deployed.createCharcoalProject(123, 1, "hola");
      await deployed.mint(0, 123);
      await expect(deployed.mint(0, 123)).to.be.revertedWith("No C02W3 available to this project");
    })

  });
});