const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe("JustCounter Test Suite", function () {
    // define loadFixture
    // fixtures can return anything you consider useful for your tests
    const deployTokenFixture = async () => {
        const [owner, addr1, addr2] = await ethers.getSigners();
        const JustCounter = await ethers.deployContract("JustCounter");
        return { JustCounter, owner, addr1, addr2 };
    }

    describe("Post Deployment State", async () => {
        it("Should return state variables", async () => {
            const { JustCounter } = await loadFixture(deployTokenFixture);
            expect(await JustCounter.count()).to.equal(0);
            expect(await JustCounter.underCount()).to.equal(0);
        })
    })



});
