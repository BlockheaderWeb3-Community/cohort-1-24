// define loadFixture
// fixtures can return anything you consider useful for your tests

const { ethers } = require("hardhat");
async function deployContractFixture(contractName) {
  const ContractInstance = await ethers.deployContract(contractName);

  console.log("cont");
  return { ContractInstance };
}

async function getGasFee(transactionHash) {
  const transactionReceipt = await ethers.provider.getTransactionReceipt(transactionHash);
  const gasUsed = transactionReceipt.gasUsed;
  const gasPrice = (await ethers.provider.getGasPrice()).toBigInt(); // Convert to BigInt
  const gasFee = gasUsed.mul(gasPrice);
  return gasFee;
}

module.exports = { deployContractFixture, getGasFee };
