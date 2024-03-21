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

    mapping(address => Student) public studentsMapping;
    mapping(address => mapping(uint => Student)) public studentsMap;
    Student[] public listOfStudents;

    //  * @dev Set contract deployer as admin
    //  */
    constructor() {
        admin = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
    }

    // function addStudent(address studentAddress, uint8 _studentId, string memory _name, uint8 _age, bool _isActive, bool _isPunctual) external {
    //     require(msg.sender == admin, 'only admin can add student');
    // // validate inputs
    //    require(_studentId != 0, 'please provide valid ID');
    //    require(bytes(_name).length != 0, 'name length must be >= 3');
    //    require(_age >= 18, 'you must not be underage');
    //    Student memory student;

    //    // instantiate student struct
    //    student.studentId = _studentId;
    //    student.name = _name;
    //    student.age = _age;
    //    student.isActive = _isActive;
    //    student.isPunctual = _isPunctual;

    //    // map student struct as value to the passed-in address as key
    //    // this ensures that one can retrieve a student profile by passing in an address
    //    studentsMapping[studentAddress] = student;

    //    // add new student to the array of Student array of struct
    //    listOfStudents.push(student);
    // }
    function addStudent(
        address studentAddress,
        string memory _name,
        uint8 _age,
        bool _isActive,
        bool _isPunctual
    ) external {
        require(msg.sender == admin, "only admin can add student");
        // validate inputs
        //    require(_studentId != 0, 'please provide valid ID');
        require(bytes(_name).length != 0, "name length must be >= 3");
        require(_age >= 18, "you must not be underage");
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
        listOfStudents.push(student); // 10million
    }

    function getStudentByAddress(
        address studentAddress
    ) public view returns (Student memory) {
        return studentsMapping[studentAddress];
    }

    function getTotalNumberOfStudents() public view returns (uint256) {
        return listOfStudents.length;
    }

    function getStudentFromListOfStudentsArray(
        uint256 studentIndex
    ) public view returns (Student memory) {
        return listOfStudents[studentIndex];
    }
}
