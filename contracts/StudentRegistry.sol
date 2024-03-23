// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title StudentRegistry
 * @dev create students & retrieve already-created students
 */

contract StudentRegistry {
    address public admin;
    uint256 studentCounter;

    struct Student {
        uint256 studentId;
        string name;
        uint8 age;
        bool isActive;
        bool isPunctual;
    }

    uint public StudentCounter;

    mapping(address => mapping(uint => Student)) public studentsMap;

    //event declaration to track all that a function is doing
    event StudentAdded(
        address caller,
        string message,
        address studentAddress, 
        string name,
        uint8 age,
        bool isActive,
        bool isPunctual);

    //  * @dev Set contract deployer as admin
    //  */
    constructor() {
        admin = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
    }

    modifier isAdminAndStudentIsValid(string memory _name, uint _age) {

        require(msg.sender == admin, "only admin can add student");
        // validate inputs
        //    require(_studentId != 0, 'please provide valid ID');
        require(bytes(_name).length != 0, "name length must be >= 3");
        require(_age >= 18, "you must not be underage");
        
        _;
        
    }

    function addStudent(
        address studentAddress,
        string memory _name,
        uint8 _age,
        bool _isActive,
        bool _isPunctual
    ) external isAdminAndStudentIsValid(_name, _age) {
      
        Student memory student;

        // instantiate student struct
        studentCounter += 1;

        student.studentId = studentCounter;
        student.name = _name;
        student.age = _age;
        student.isActive = _isActive;
        student.isPunctual = _isPunctual;

        // map student struct as value to the passed-in address as key
        // this ensures that one can retrieve a student profile by passing in an address
        studentsMap[studentAddress][studentCounter] = student;
        //    studentsMapping[studentAddress] = student;

        // add new student to the array of Student array of struct
        //listOfStudents.push(student); // 10million

        //here we emit a student when added
        emit StudentAdded(
            msg.sender,
            "New Student has been added:",
            studentAddress, 
            _name,
            _age,
            _isActive,
            _isPunctual);
    }

    function getStudentByAddress(
        address _studentAddress,
        uint _studentId
    ) public view returns (Student memory) {

        return studentsMap[_studentAddress][_studentId];
    }

    function getTotalNumberOfStudents() public view returns (uint256) {
      
        return studentCounter;
    }    

    function getStudent(
        address _studentAddress, uint _studentId
    ) public view returns (Student memory) {
        return studentsMap[_studentAddress][_studentId];
    }    

}
