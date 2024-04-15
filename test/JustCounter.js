const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("JustCounter Test Suite", function () {
  // define loadFixture
  // fixtures can return anything you consider useful for your tests
  const deployTokenFixture = async () => {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const JustCounter = await ethers.deployContract("JustCounter");
    return { JustCounter, owner, addr1, addr2 };
  };

  describe("Post Deployment State Variables", async () => {
    it("Should return state variables", async () => {
      const { JustCounter } = await loadFixture(deployTokenFixture);
      expect(await JustCounter.count()).to.equal(0);
      expect(await JustCounter.underCount()).to.equal(0);
    });
  });

  describe("State Variables Changes", async () => {
    it("Should store number", async () => {
      let amount = 5;
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // get current state variable count
      let count1 = await JustCounter.count();
      console.log("count before state change___", count1);
      // write assertion statement for count1
      expect(count1).to.equal(0);

      // store count (transaction)
      await JustCounter.store(amount);
      let count2 = await JustCounter.count();
      // write assertion statement for count after store txn
      expect(count2).to.equal(amount);
    });

    it.only("Should retrieve count", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // get current state variable count
      let count1 = await JustCounter.retrieve();
      console.log("retrieve before state change___", count1);

      // write assertion statement for count1
      expect(count1).to.equal(0);
    });
  });
  


});
