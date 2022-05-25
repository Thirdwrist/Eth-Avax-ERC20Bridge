// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // const bridgeAddress = (await hre.ethers.getSigners())[5].address;
  const [bridgeAddress] = await ethers.getSigners();

  // Vault deployment
  const Vault = await hre.ethers.getContractFactory('Vault');
  const vault = await Vault.deploy();
  await vault.deployed();

  //  EthGateway deployment
  const EthGateway = await hre.ethers .getContractFactory('EthGateway');
  const ethGateway = await EthGateway.deploy(vault.address, bridgeAddress.address); 
  await ethGateway.deployed();

  // AvaxGateway 
  const AvaxGateway = await hre.ethers.getContractFactory("AvaxGateway");
  const avaxGateway = await AvaxGateway.deploy(bridgeAddress.address);
  await avaxGateway.deployed();

  // Native ERC20 token deployment
  const NativeToken = await hre.ethers.getContractFactory('NativeToken');
  const nativeToken = await NativeToken.deploy();
  await nativeToken.deployed();

  // Wrapped ER20 token deployment
  const WrappedToken = await hre.ethers.getContractFactory('WrappedToken');
  const wrappedToken = await WrappedToken.deploy(avaxGateway.address);
  await wrappedToken.deployed();




  console.log("Vault deployed to:", vault.address);
  console.log("EthGateway deployed to:", ethGateway.address);
  console.log("NativeToken deployed to:", nativeToken.address);
  console.log("WrappedToken deployed to:", wrappedToken.address);
  console.log("AvaxGateway deployed to:", avaxGateway.address);
  console.log("Bridge address:",  bridgeAddress.address);
  


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
