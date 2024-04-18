// define loadFixture
// fixtures can return anything you consider useful for your tests

const { ethers } = require("hardhat")
async function deployContractFixture(contractName) {
    const ContractInstance = await ethers.deployContract(contractName);

    console.log("cont")
    return { ContractInstance };
};


module.exports = { deployContractFixture }
