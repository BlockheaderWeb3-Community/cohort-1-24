// define loadFixture
// fixtures can return anything you consider useful for your tests
async function deployTokenFixture(contractName) {
    const ContractInstance = await ethers.deployContract(contractName);
    return { ContractInstance };
};


module.exports = { deployTokenFixture }
