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
      const balanceBefore = await ETHBankContract.ethBalances(addr1.address);

      // Assert that the sender's balance is 0 before the deposit
      expect(balanceBefore).to.eq(0);
      const depositAmount = ethers.utils.parseEther("1");

      // Assert that the deposit amount is not 0
      expect(depositAmount).not.to.eq(0);

      // Deposit the ETH
      const transaction = await ETHBankContract.connect(addr1).depositETH({ value: depositAmount });
      const receipt = await transaction.wait();

      // Assert that there is a transaction receipt
      expect(receipt).to.exist;

      // Get the balance of addr1 after the deposit
      const balanceAfter = await ETHBankContract.ethBalances(addr1.address);

      // Assert that the new balance of addr1 is equal to depositAmount
      expect(balanceAfter).to.eq(depositAmount);

      // Assert that the Deposit event is emitted
      expect(receipt.events[0])
        .to.emit(ETHBankContract, "Deposit")
        .withArgs(addr1.address, depositAmount, balanceBefore, balanceAfter);
    });
  });

  it("Should withdraw ETH", async () => {
    const { ETHBankContract, addr1 } = await loadFixture(deployTokenFixture);
    const depositAmount = ethers.utils.parseEther("1");

    // Deposit some ETH to the contract
    await ETHBankContract.connect(addr1).depositETH({ value: depositAmount });

    // Get the balance of addr1 before the withdrawal
    const balanceBefore = await ETHBankContract.ethBalances(addr1.address);

    // Assert that addr1 balance is not 0
    expect(balanceBefore).not.to.eq(0);

    const withdrawalAmount = ethers.utils.parseEther("0.5");

    // Assert that withdraw amount is less than balance
    expect(balanceBefore).to.be.at.least(withdrawalAmount);

    // Withdraw ETH from the contract
    const transaction = await ETHBankContract.connect(addr1).withdrawETH(withdrawalAmount);
    const receipt = await transaction.wait();

    // Get the balance of addr1 after the withdrawal
    const balanceAfter = await ETHBankContract.ethBalances(addr1.address);

    // Assert that the balance of addr1 is updated after the withdrawal
    expect(balanceAfter).to.eq(balanceBefore.sub(withdrawalAmount));

    // Assert that the Withdraw event was emitted
    expect(receipt.events[0])
      .to.emit(ETHBankContract, "Withdraw")
      .withArgs(addr1.address, withdrawalAmount, balanceBefore, balanceAfter);
  });
});
