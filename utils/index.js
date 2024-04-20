const deployTokenFixture = async (contractName) => {
  const [owner, addr1, addr2] = await ethers.getSigners();
  const JustCounter = await ethers.deployContract(contractName);
  return { JustCounter, owner, addr1, addr2 };
};

module.exports = { deployTokenFixture };
