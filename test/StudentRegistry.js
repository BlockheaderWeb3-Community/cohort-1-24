const { expect } = require("chai");

describe("StudentRegistry", function () {
	let studentRegistry;

	beforeEach(async function () {
		const StudentRegistry = await ethers.getContractFactory("StudentRegistry");
		studentRegistry = await StudentRegistry.deploy();
		await studentRegistry.addStudent(
			"0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			1,
			"Zinta",
			20,
			true,
			true
		);
		await studentRegistry.addStudent(
			"0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			2,
			"Seun",
			24,
			false,
			true
		);
	});

	it("Should return the list of students", async function () {
		const students = await studentRegistry.getListOfStudents();
		expect(students).to.have.lengthOf(2);

		expect(students[0][0]).to.equal(1); 
		expect(students[0][1]).to.equal("Zinta");
		expect(students[0][2]).to.equal(20); 
		expect(students[0][3]).to.equal(true);
		expect(students[0][4]).to.equal(true);

		
	});
});
