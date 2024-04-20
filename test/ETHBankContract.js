const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("ETHBank Test Suite", function () {
  // define loadFixture
  // fixtures can return anything you consider useful for your tests
  const deployTokenFixture = async () => {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const ETHBankContract = await ethers.deployContract("ETHBankContract");
    return { ETHBankContract, owner, addr1, addr2 };
  };

  describe("Post Deployment State Variables", async () => {
    it("Should return state variables", async () => {
      // extract loadFixture variables
      const { ETHBankContract, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
      expect(await ETHBankContract.owner()).to.eq(owner.address);
      expect(await ETHBankContract.ethBalances(owner.address)).to.eq(0);
    });
  });

  describe("Transactions", async () => {
    it("Should deposit ETH", async () => {
      const { ETHBankContract, addr1 } = await loadFixture(deployTokenFixture);

      // Get the balance of addr1 before the deposit
      const beforeBalance = await ETHBankContract.ethBalances(addr1.address);

      // assert that the sender's balance is 0 before the deposit
      expect(beforeBalance).to.eq(0);

      const depositAmount = ethers.utils.parseEther("1");

      // assert that the deposit amount is not 0
      expect(depositAmount).not.to.eq(0);

      // Deposit the ETH
      const transaction = await ETHBankContract.connect(addr1).depositETH({ value: depositAmount });
      const receipt = await transaction.wait();

      // assert that there is a transaction receipt
      expect(receipt).to.exist;

      // Get the balance of addr1 after the deposit
      const newBalance = await ETHBankContract.ethBalances(addr1.address);

      // assert that the new balance of addr1 is equal to depositAmount
      expect(newBalance).to.eq(depositAmount);

      // assert that the Deposit event was emitted with the correct arguments
      expect(receipt.events[0])
        .to.emit(ETHBankContract, "Deposit")
        .withArgs(addr1.address, depositAmount, beforeBalance, newBalance);
    });
  });
});
