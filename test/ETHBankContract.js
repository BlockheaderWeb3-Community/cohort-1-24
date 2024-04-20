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
      // extract loadFixture variables
      const { ETHBankContract, owner } = await loadFixture(deployTokenFixture);
      await ETHBankContract.connect(owner).depositETH({ value: ethers.utils.parseEther("1") });
      expect(await ETHBankContract.ethBalances(owner.address)).to.eq(ethers.utils.parseEther("1"));
    });

    it("Should withdraw ETH", async () => {
      // extract loadFixture variables
      const { ETHBankContract, owner, addr1 } = await loadFixture(deployTokenFixture);

      // deposit ETH to contract
      await ETHBankContract.connect(addr1).depositETH({ value: ethers.utils.parseEther("1") });

      // withdraw ETH from contract
      await ETHBankContract.connect(addr1).withdrawETH(ethers.utils.parseEther("0.5"));

      // assert withdrawal transaction
      expect(await ETHBankContract.ethBalances(addr1.address)).to.eq(ethers.utils.parseEther("0.5"));
    });

    it("Should withdraw all ETH", async () => {
      // extract loadFixture variables
      const { ETHBankContract, addr2 } = await loadFixture(deployTokenFixture);

      // deposit ETH to contract
      await ETHBankContract.connect(addr2).depositETH({ value: ethers.utils.parseEther("1") });

      // withdraw all ETH from contract
      await ETHBankContract.connect(addr2).withdrawAllETH();

      // assert owner balance
      expect(await ETHBankContract.ethBalances(addr2.address)).to.eq(0);
    });

    it("Should allow owner to withdraw all ETH", async () => {
      // extract loadFixture variables
      const { ETHBankContract, owner } = await loadFixture(deployTokenFixture);

      // deposit ETH to contract
      await ETHBankContract.connect(owner).depositETH({ value: ethers.utils.parseEther("1") });

      // call emergency owner withdraw
      await ETHBankContract.connect(owner).ownerOnlyWithdraw();

      // assert owner balance
      expect(await ETHBankContract.ethBalances(owner.address)).to.eq(ethers.utils.parseEther("1"));

      // assert contract balance
      expect(await ETHBankContract.getContractEthBalance()).to.eq(ethers.utils.parseEther("0"));
    });

    it("Should not allow non-owner to withdraw all ETH", async () => {
      // extract loadFixture variables
      const { ETHBankContract, owner, addr1 } = await loadFixture(deployTokenFixture);

      // deposit ETH to contract
      await ETHBankContract.connect(owner).depositETH({ value: ethers.utils.parseEther("1") });

      // asssert only owner can call ownerOnlyWithdraw
      await expect(ETHBankContract.connect(addr1).ownerOnlyWithdraw()).to.be.revertedWith(
        "only owner can call emergency withdraw"
      );
    });
  });
});
