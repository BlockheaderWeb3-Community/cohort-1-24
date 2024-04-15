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
      let count1 = await JustCounter.retrieve();
      console.log("retrieve before state change___", count1);

      // write assertion statement for count1
      expect(count1).to.equal(0);
     });

    
     it("Should increase count", async () => {
        // get loadFixture variables
       const { JustCounter } = await loadFixture(deployTokenFixture);
       // get current state variable Increasecount
       await JustCounter.increaseCount();
       console.log("increase before state change___", JustCounter.count());
       expect(await JustCounter.count()).to.equal(+ 1);
       });

     it("Should decrease count", async () => {
        // get loadFixture variables
        const { JustCounter } = await loadFixture(deployTokenFixture);

        await JustCounter.store(5);
        let count1 = await JustCounter.count();
        await JustCounter.decreaseCount();
        let count2 = await JustCounter.count();
        console.log(" decrease count before state change___", count1);
        expect(count2).to.equal(count1 - 1);
     });
     it("Should increase underCount", async () => {
        const { JustCounter } = await loadFixture(deployTokenFixture);

        let underCount1 = await JustCounter.underCount();
        await JustCounter.increaseUnderCount();
        let underCount2 = await JustCounter.underCount();
        console.log("increase undercount before state change___");
        expect(underCount2).to.equal(underCount1 + 1);
    });
    it("Should decrease underCount", async () => {
        // get loadFixture variables
        const { JustCounter } = await loadFixture(deployTokenFixture);
         // get current state variable decrese count
        let underCount1 = await JustCounter.underCount();
        await JustCounter.decreaseUnderCount();
        let underCount2 = await JustCounter.underCount();
        console.log("decrease undercount before state change___"  );
        expect(underCount2).to.equal(underCount1 - 1);
    });
    it("Should return underCount value", async () => {
        // get loadFixture variables
        const { JustCounter } = await loadFixture(deployTokenFixture);
        await JustCounter.increaseUnderCount();
        console.log("return undercount value before state change___");
        expect(await JustCounter.getUnderCount()).to.equal(1);
    });


     });

     });
    


  
