const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");
const { deployTokenFixture } = require("../utils/index.js");

describe("JustCounter Test Suite", function () {
  // define loadFixture
  // fixtures can return anything you consider useful for your tests
  describe("Post Deployment State Variables", async () => {
    it("Should return state variables", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture("JustCounter"));
      expect(await JustCounter.count()).to.equal(0);
      expect(await JustCounter.underCount()).to.equal(0);
    });
  });

  describe("Transactions", async () => {
    let amount = 5;

    it("Should store number", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      let count1 = await JustCounter.count();
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
      let count1 = await JustCounter.count();
      // write assertion statement for count1
      expect(count1).to.equal(0);
      // store count (transaction)
      await JustCounter.store(amount);

      let count2 = await JustCounter.count();
      // write assertion statement for count after store txn
      expect(count2).to.equal(amount);
    });

    it("Should increase count", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // Set count to 10 for decrement test
      await JustCounter.store(4);
      // get current state variable count
      let count1 = await JustCounter.count();
      // increase count by 1
      await JustCounter.increaseCount();
      let count2 = await JustCounter.count();
      // write assertion statement for count after increaseCount txn
      expect(count2).to.equal(5);
    });

    it("Should decrease count", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // Set count to 10 for decrement test
      await JustCounter.store(10);
      // get current state variable count
      let count1 = await JustCounter.count();
      // decrement count by 1
      await JustCounter.decreaseCount();
      let count2 = await JustCounter.count();
      // write assertion statement for count after decreaseCount txn
      expect(count2).to.equal(count1 - 1);
    });

    it("Should return appropriate boolean value if count is even or odd", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // Set count to even number
      await JustCounter.store(4);
      // write assertion statement to check count is even
      expect(await JustCounter.isCountEven()).to.equal(true);
      // Set count to odd number
      await JustCounter.store(7);
      // write assertion statement to check count is odd
      expect(await JustCounter.isCountEven()).to.equal(false);
    });

    it("Should increase underCount", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // assert that default underCount value is 0
      expect(await JustCounter.underCount()).to.equal(0);
      // get current state variable underCount
      let underCount1 = await JustCounter.underCount();
      await JustCounter.increaseUnderCount();
      let underCount2 = await JustCounter.underCount();
      expect(underCount2).to.equal(underCount1 + 1);
    });

    it("Should decrease underCount", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // assert that default underCount value is 0
      expect(await JustCounter.underCount()).to.equal(0);
      let underCount1 = await JustCounter.underCount();
      await JustCounter.decreaseUnderCount();
      let underCount2 = await JustCounter.underCount();
      expect(underCount2).to.equal(underCount1 - 1);
    });

    it("Should return underCount value", async () => {
      // get loadFixture variables
      const { JustCounter } = await loadFixture(deployTokenFixture);
      // Increase underCount
      await JustCounter.increaseUnderCount();
      // Increment underCount once
      expect(await JustCounter.getUnderCount()).to.equal(1);
    });
  });
});
