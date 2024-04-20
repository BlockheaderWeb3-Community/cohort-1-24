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
      expect(await ETHBankContract.owner()).to.eq(owner.address)
      expect(await ETHBankContract.ethBalances(owner.address)).to.eq(0)
    });
  });

  describe("Transactions", async () => {
    it("should return state variable", async () => {
      // extract loadFixture variables
      const { ETHBankContract, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
      const depositAmount = ethers.utils.parseEther("1"); //1 ETh

      // deposit ETH into the contract 
      await ETHBankContract.depositETH({ value: depositAmount });

      //Check the balances of the contracts and the sender
      expect(await ETHBankContract.getContractEthBalance()).to.equal(depositAmount);
      expect(await ETHBankContract.ethBalances(owner.address)).to.equal(depositAmount);

    });

    it("Should withdraw ETH from the contract", async () => {
      const { ETHBankContract, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
      const depositAmount = ethers.utils.parseEther("1"); // 1 ETH
      const withdrawAmount = ethers.utils.parseEther("0.5"); // 0.5 ETH

      // Deposit ETH into the contract
      await ETHBankContract.depositETH({ value: depositAmount });

      // Withdraw ETH from the contract
      await ETHBankContract.withdrawETH(withdrawAmount);

      // Check the balance of the contract and the sender
      expect(await ETHBankContract.getContractEthBalance()).to.equal(depositAmount.sub(withdrawAmount));
      expect(await ETHBankContract.ethBalances(owner.address)).to.equal(depositAmount.sub(withdrawAmount));
    });

    it("Should withdraw all ETH from the contract", async () => {
      const { ETHBankContract, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
      const depositAmount = ethers.utils.parseEther("1"); // 1 ETH

      // Deposit ETH into the contract
      await ETHBankContract.depositETH({ value: depositAmount });

      // Withdraw all ETH from the contract
      await ETHBankContract.withdrawAllETH();

      // Check the balance of the contract and the sender
      expect(await ETHBankContract.getContractEthBalance()).to.equal(0);
      expect(await ETHBankContract.ethBalances(owner.address)).to.equal(0);
    });

    it("Should allow the owner to withdraw all ETH from the contract", async () => {
      const { ETHBankContract, owner, addr1, addr2 } = await loadFixture(deployTokenFixture);
      const depositAmount = ethers.utils.parseEther("1"); // 1 ETH

      // Deposit ETH into the contract
      await ETHBankContract.depositETH({ value: depositAmount });

      // Withdraw all ETH from the contract
      await ETHBankContract.ownerOnlyWithdraw();

      // Check the balance of the contract and the sender
      expect(await ETHBankContract.getContractEthBalance()).to.equal(0);
      expect(await ETHBankContract.ethBalances(owner.address)).to.equal(1000000000000000000n);
    });
  });
});



