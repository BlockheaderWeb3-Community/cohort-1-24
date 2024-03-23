// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

/**
 * @title StudentRegistry
 * @dev create students, retrieve & delete already created students
 */
contract StudentRegistry {

    struct Student {
        uint studentId;
        string name;
        uint8 age;
        bool isActive;
        bool isPunctual;
    }

    struct addressId {
        address studentAddress;
        uint studentId;
    }

    address admin;

    uint studentCounter;

    mapping(address => mapping(uint => Student)) public studentsRecords;

    addressId[] addressIdPairs;

	/**
	 * @ dev Validator to check that valid students details are passed upon creation of student
	 */
    modifier isValidStudentDetails (string memory _name, uint _age) {
        require(bytes(_name).length != 0, "name length must be >= 3");
        require(_age >= 18, "You must not be underage");
        _;
    }

	/**
	 * @ dev Validator specify some admin previlleges
	 */
    modifier isAdmin() {
        require(msg.sender == admin, "Only-Admin prevelleges");
        _;
    }

    /**
     * @dev Set contract deployer as admin
     */
    constructor() {
        admin = msg.sender;
    }

	/**
	 * @ dev Add an instance of student to the studentRegister
	 * @ param: studentAddress, _name, _age, _isActive, _isPunctual
	 */
    function addStudent(
        address studentAddress,
        string memory _name,
        uint8 _age,
        bool _isActive,
        bool _isPunctual
    ) external isValidStudentDetails(_name, _age) isAdmin {
        Student memory student;
        addressId memory addressIdPair;

        studentCounter += 1;
        student.studentId = studentCounter;
        student.name = _name;
        student.age = _age;
        student.isActive = _isActive;
        student.isPunctual = _isPunctual;

        studentsRecords[studentAddress][student.studentId] = student;

        addressIdPair.studentAddress = studentAddress;
        addressIdPair.studentId = student.studentId;

        addressIdPairs.push(addressIdPair);

    }

	/**
	 * @ dev Gets student address
	 * @ param _id: the student id
	 * Return: student address on Success. Otherwise address 0
	 */

    function getStudentAddress(uint _id) public view returns(address) {
        for (uint i; i < addressIdPairs.length; i++){
            if (addressIdPairs[i].studentId == _id){
                return addressIdPairs[i].studentAddress;
            }
        }
        return address(0);
    } 

	/**
	 * @ dev Gets student id
	 * @ param _address: the student's address
	 * Return: student id on Success. Otherwise 0
	 */

    function getStudentId(address _address) public view returns(uint) {
        for (uint i; i < addressIdPairs.length; i++){
            if (addressIdPairs[i].studentAddress == _address){
                return addressIdPairs[i].studentId;
            }
        }
        return 0;
    } 

	/**
	 * @ dev Computes total number of student
	 * Return: number of student
	 */

    function getTotalStudents() public view returns(uint) {
        return studentCounter;
    }

	/**
	 * @ dev Gets an instance of a student in the mapping
	 * Param _address: student address, _id: student id
	 * Return: An instance of a student. otherwise default value for each field
	 */

    function getStudent(address _address, uint _id) public view returns(Student memory) {
        return studentsRecords[_address][_id];
    }

	/**
	 * @ dev deletes an instance of a student in the mapping
	 * Param _address: student address, _id: student id
	 */

    function deleteStudent(address _address, uint _id) public isAdmin {
        Student storage studentToDelete = studentsRecords[_address][_id];

        studentToDelete.name = "";
        studentToDelete.age = 0;
        studentToDelete.isActive = false;
        studentToDelete.isPunctual = false;
    }
}
