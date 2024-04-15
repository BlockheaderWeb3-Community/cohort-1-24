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

    it("Should retrieve count", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // get current state variable count
      let count = await JustCounter.retrieve();
      console.log("count before state change___", count);
      // write assertion statement for count
      expect(count).to.be.instanceOf(ethers.BigNumber);
      expect(count).to.equal(0);
    });

    it("Should increase count", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // get current state variable count
      console.log("count before state change___", JustCounter.count());
      // increase count
      await JustCounter.increaseCount();
      // write assertion statement for count
      expect(await JustCounter.count()).to.equal(1);
    });

    it("Should decrease count", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // get current state variable count
      console.log("count before state change___", JustCounter.count());
      // decrease count
      await JustCounter.decreaseCount();
      // write assertion statement for count
      expect(await JustCounter.count()).to.equal(0);
    });

    it("Should check even count", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // get current state variable count
      console.log("count before state change___", JustCounter.count());
      // check even count
      let isCountEven = await JustCounter.isCountEven();
      // write assertion statement for count
      expect(isCountEven).to.equal(true);
      // increase count
      await JustCounter.increaseCount();
      // check even count
      isCountEven = await JustCounter.isCountEven();
      // write assertion statement for count
      expect(isCountEven).to.equal(false);
    });

    it("Should increase underCount", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // get current state variable underCount
      console.log(
        "underCount before state change___",
        JustCounter.underCount()
      );
      // increase underCount
      await JustCounter.increaseUnderCount();
      // write assertion statement for underCount
      expect(await JustCounter.underCount()).to.equal(1);
    });

    it("Should decrease underCount", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // get current state variable underCount
      console.log(
        "underCount before state change___",
        JustCounter.underCount()
      );
      // decrease underCount
      await JustCounter.decreaseUnderCount();
      // write assertion statement for underCount
      expect(await JustCounter.underCount()).to.equal(-1);
    });

    it.only("Should retrieve underCount", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // get current state variable underCount
      let underCount = await JustCounter.getUnderCount();
      console.log("count before state change___", underCount);
      // write assertion statement for count
      expect(underCount).to.be.instanceOf(ethers.BigNumber);
      expect(underCount).to.equal(0);
    });
  });
});
