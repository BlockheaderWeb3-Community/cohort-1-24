// Import necessary modules and libraries
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

// Test suite for the JustCounter contract
describe("JustCounter Test Suite", function () {
    // define loadFixture
    // fixtures can return anything you consider useful for your tests
    const deployTokenFixture = async () => {
        const [owner, addr1, addr2] = await ethers.getSigners();
        const JustCounter = await ethers.deployContract("JustCounter");
        return { JustCounter, owner, addr1, addr2 };
    }

	// Test for pre-deployment
    describe("Pre-Deployment State Variables", async () => {
        it("Should return state variables", async () => {
            const { JustCounter } = await loadFixture(deployTokenFixture);
            expect(await JustCounter.count()).to.equal(0);
            expect(await JustCounter.underCount()).to.equal(0);
        })
    })

	// test for post deployment state variables
    describe.only("State Variables Changes", async () => {

		let amount = 5
		let count1 = 0

        it("Should store number", async () => {
            // let amount = 5
            // get loadFixture variables
            const { JustCounter } = await loadFixture(deployTokenFixture);
            // get current state variable count
            count1 = await JustCounter.count()
            console.log("count before state change___", count1)
            // write assertion statement for count1
            expect(count1).to.equal(0);

            // store count (transaction)
            await JustCounter.store(amount)
            let count2 = await JustCounter.count()
            // write assertion statement for count after store txn
            expect(count2).to.equal(amount);
        })

		// Test for retrieve number from state
		it ("Should retrieve number", async () => {

			const { JustCounter } = await loadFixture(deployTokenFixture);
			
			await JustCounter.store(amount)
			let count2 = await JustCounter.retrieve()
			expect(count2).to.equal(amount);
		})

		// Test for increament of count by one
		it ("Should increase count by one", async () => {

			const { JustCounter } = await loadFixture(deployTokenFixture);

			await JustCounter.store(amount)
			await JustCounter.increaseCount()
			let count3 = await JustCounter.retrieve()
			expect(count3).to.equal(amount + 1);
		})

		// Test for decreament by one
		it ("Should decrease count by one", async () => {
			const { JustCounter } = await loadFixture(deployTokenFixture);

			await JustCounter.store(amount)
			await JustCounter.decreaseCount()
			let counts = await JustCounter.retrieve()
			expect(counts).to.equal(amount - 1);
		})

		// Test for even number checker
		it ("Checks if number is even", async () => {
			const { JustCounter } = await loadFixture(deployTokenFixture);

			await JustCounter.store(amount)
			let counts = await JustCounter.isCountEven()
			expect(counts).to.equal(false);
		})

		// Test to get current value of undercount
		it ("Gets the current value of undercount variable", async () => {
			const { JustCounter } = await loadFixture(deployTokenFixture);

			let count = await JustCounter.getUnderCount();
			expect(count).to.equal(0)
		})

		// Test to increase undercount variable by one
		it ("Increases Undercount variable by one", async () => {
			const { JustCounter } = await loadFixture(deployTokenFixture);

			await JustCounter.increaseUnderCount();
			let counts = await JustCounter.getUnderCount();
			expect(counts).to.equal(1);
		})
		
		// Test to decrease undercount by one
		it ("Decrease Undercount variable by one", async () => {
			const { JustCounter } = await loadFixture(deployTokenFixture);

			await JustCounter.decreaseUnderCount();
			let counts = await JustCounter.getUnderCount();
			expect(counts).to.equal(-1);
		})

    })
});
