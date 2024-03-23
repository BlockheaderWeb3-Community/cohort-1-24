const { expect } = require("chai");

describe("StudentRegistry", function () {
	let studentRegistry;

	beforeEach(async function () {
		const StudentRegistry = await ethers.getContractFactory("StudentRegistry");
		studentRegistry = await StudentRegistry.deploy();
		await studentRegistry.addStudent(
			"0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"Crypto",
			20,
			true,
			true
		);
		await studentRegistry.addStudent(
			"0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
			"Zombie",
			24,
			false,
			true
		);
	});


	it("Should retreive student by address and studentId ", async function () {
		const students = await studentRegistry.getStudentDetails("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", 1);
		expect(students.name).to.equal("Crypto");
		expect(students.age).to.equal(20);
	});


	it("Should retreive total number of students from student ", async function () {
		const students = await studentRegistry.studentsCounter();
		expect(students).to.equal(2); 
		
	});

	it("Should retreive student by studentAddress and studentId ", async function () {
		const students = await studentRegistry.getStudentDetails("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", 1);
		expect(students.name).to.equal("Crypto");
		expect(students.age).to.equal(20);
	});



});
