const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { ethers } = require("hardhat");
const { getGasFee } = require("../utils");

describe.only("ETHBank Test Suite", function () {
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

  describe("Deposit Validations", async () => {
    // validate attempt to send 0 ETH to ETHBankContract
    it("Should revert attempt to deposit 0 ETH", async () => {
      const { ETHBankContract, addr1 } = await loadFixture(deployTokenFixture);
      const depositAmount = ethers.utils.parseEther("0.1");
      await expect(ETHBankContract.connect(addr1).depositETH({ value: depositAmount })).to.be.revertedWith(
        "you must add ETH"
      );
    });
  });

  describe("Deposit Transactions", async () => {
    it.only("Should deposit ETH", async () => {
      const { ETHBankContract, addr1, owner } = await loadFixture(deployTokenFixture);
      const { parseEther, formatEther } = ethers.utils;
      const { getBalance } = ethers.provider;
      const depositAmount = parseEther("1");
      //assert the contract balance before deposit
      expect(await getBalance(ETHBankContract.address)).to.eq(parseEther("0"));
      // Get the balance of addr1 before the deposit
      const balanceBefore = await ETHBankContract.ethBalances(addr1.address);
      // assert that the sender's balance is 0 before the deposit
      expect(balanceBefore).to.eq(0);
      const addr1BalanceBefore = await getBalance(addr1.address);
      // assert that the sender's balance is greater than or equal to  depositAmount
      expect(addr1BalanceBefore).to.greaterThanOrEqual(depositAmount);
      // Deposit the ETH
      // await ETHBankContract.connect(addr1).depositETH();
      const transaction = await ETHBankContract.connect(addr1).depositETH({ value: depositAmount });
      // Get gas price used by the transaction
      const gasUsed = await getGasFee(transaction.hash);
      // Get the balance of addr1 after the deposit
      const balanceAfter = await ETHBankContract.ethBalances(addr1.address);
      //assert that the new balance of addr1 is equal to depositAmount
      expect(balanceAfter).to.eq(depositAmount);
      // await provider.getBalance(user1.address);
      const addr1ETHBalanceAfterDeposit = await getBalance(addr1.address);
      // assert that addr1ETHBalanceAfterDeposit is equal to depositAmount - gasUsed
      // expect(formatEther(addr1ETHBalanceAfterDeposit)).to.eq(addr1BalanceBefore - (depositAmount + gasUsed));
      //Get contract balance after deposit
      const ethContractBalance = await getBalance(ETHBankContract.address);
      // assert that ethContractBalance is equal to depositAmount
      expect(ethContractBalance).to.eq(depositAmount);
    });
  });

  describe("Deposit Events", async () => {
    // validate attempt to send 0 ETH to ETHBankContract
    it("Should revert attempt to deposit 0 ETH", async () => {
      const { ETHBankContract, addr1, owner } = await loadFixture(deployTokenFixture);
      // Get the balance of addr1 before the deposit
      const balanceBefore = await ETHBankContract.ethBalances(addr1.address);
      // assert that the sender's balance is 0 before the deposit
      expect(balanceBefore).to.eq(0);
      const depositAmount = ethers.utils.parseEther("1");
      // assert that the deposit amount is not 0
      expect(depositAmount).not.to.eq(0);
      // Deposit the ETH
      // const transaction = await ETHBankContract.connect(addr1).depositETH({ value: depositAmount });
      await expect(ETHBankContract.connect(addr1).depositETH({ value: depositAmount }))
        .to.emit(ETHBankContract, "Deposit")
        .withArgs(addr1.address, depositAmount, balanceBefore, ethers.utils.parseEther("5"));
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

    // Assert that withdraw amount is not greater than balance
    expect(balanceBefore).to.be.at.least(withdrawalAmount);

    // Withdraw ETH from the contract
    const transaction = await ETHBankContract.connect(addr1).withdrawETH(withdrawalAmount);
    const receipt = await transaction.wait();

    // Get the balance of addr1 after the withdrawal
    const balanceAfter = await ETHBankContract.ethBalances(addr1.address);

    // Assert that the balance of addr1 is correctly updated after the withdrawal
    expect(balanceAfter).to.eq(balanceBefore.sub(withdrawalAmount));

    // Assert that the Withdraw event was emitted with the correct arguments
    expect(receipt.events[0])
      .to.emit(ETHBankContract, "Withdraw")
      .withArgs(addr1.address, withdrawalAmount, balanceBefore, balanceAfter);
  });
});
