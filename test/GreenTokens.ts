const { expect } = require('chai');
const myJson = require('../artifacts/contracts/BaseToken.sol/BaseToken.json')

describe("GreenTokens", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployContract() {    

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const Contract = await ethers.getContractFactory("GreenTokens");
    const contract = await Contract.deploy();

    return { contract, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should create correctly the project", async function () {
      const { contract, owner, otherAccount } = await deployContract();
      
      // Solo usuarios con permisos de CREATOR pueden crear proyectos
      // solo el ADMIN puede asignar este permiso
      await contract._addRoll(owner.address)
      // Nombre del proyecto, maxSupply, url del json con la metadata
      // el json lo podemos generar desde el frontend y subir los archivos automaticamente
      // a pinata o cualquier proveedor IPFS, igual se valida desde el front haciedo un
      // y validando que la imagen exista
      await contract.createProject("Green Tokens", 2000, "htts//pinata/metadata.json")
      // Accedemos al proyecto 0
      const project = await contract.project(0)      
      
      // el nombre del proyecto es el que seteamos
      expect(project.projectName).to.equal("Green Tokens");
    });

    it("Should respect the maxSupply give it", async function () {
      const { contract, owner, otherAccount } = await deployContract();

      await contract._addRoll(owner.address)
      await contract.createProject("Green Tokens", 2000, "htts//pinata/metadata.json")
      const project = await contract.project(0)

      // Hasta aquí es lo mismo que arriba
      
      // Creamos una instancia del contrato ERC 1155 desplegado dinamicamente
      const baseToken = new ethers.Contract(project.tokens, myJson.abi, ethers.provider)

      // Obtenemos la uri del json con la metadata
      const uri = await baseToken.uri(0)      

      // Obtenemos el balance del owner con respecto a los dos tipos de tokens
      const NFT = await baseToken.functions.balanceOf(owner.address, 0)      
      const Token = await baseToken.functions.balanceOf(owner.address, 1)      

      // Validamos que el maxSupply sea el establecido
      expect(Token[0]).to.equal(ethers.BigNumber.from("2000"));
      expect(NFT[0]).to.equal(ethers.BigNumber.from("1"));
    });
  });

});
