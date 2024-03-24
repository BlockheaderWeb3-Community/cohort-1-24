// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

// Import interfaces

import {Ownable} from "./Ownable.sol";

contract StudentRegistry is Ownable {

    uint256 public studentsCounter;

    struct Student {
        uint256 studentId;
        string name;
        uint8 age;
        bool isActive;
        bool isPunctual;
    }

    mapping(address => mapping(uint256 => Student)) public studentsMap;

 event AddOrUpdateStudentEvent(
        address studentAddress,
        uint256 studentId,
        string name,
        uint8 age,
        bool isActive,
        bool isPunctual
    );

    event DeleteStudentEvent(address studentAddress, uint256 studentId);

    modifier isStudentDataValid(string memory _name, uint8 _age) {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_age > 0, "Age must be greater than zero");
        _;
    }

    // Function to add a new student
    function addStudent(
        address studentAddress,
        string memory _name,
        uint8 _age,
        bool _isActive,
        bool _isPunctual
    ) external isStudentDataValid(_name, _age) onlyOwner {
        studentsCounter++;

        uint256 studentId = studentsCounter;

        Student memory student = Student(
            studentId,
            _name,
            _age,
            _isActive,
            _isPunctual
        );
        studentsMap[studentAddress][studentId] = student;

        emit AddOrUpdateStudentEvent(
            studentAddress,
            studentId,
            _name,
            _age,
            _isActive,
            _isPunctual
        );
    }

    function updateStudent(
        address studentAddress,
        uint256 _studentId,
        string memory _name,
        uint8 _age,
        bool _isActive,
        bool _isPunctual
    ) external isStudentDataValid(_name, _age) onlyOwner {
        Student memory student = Student(
            _studentId,
            _name,
            _age,
            _isActive,
            _isPunctual
        );
        studentsMap[studentAddress][_studentId] = student;

        emit AddOrUpdateStudentEvent(
            studentAddress,
            _studentId,
            _name,
            _age,
            _isActive,
            _isPunctual
        );
    }

    // Function to retrieve student details
    function getStudentDetails(
        address _studentAddress,
        uint256 _studentId
    ) public view returns (Student memory) {
        return studentsMap[_studentAddress][_studentId];
    }

    // Function to delete a student
    function deleteStudent(
        address _studentAddress,
        uint256 _studentId
    ) public onlyOwner {
        delete studentsMap[_studentAddress][_studentId];

        emit DeleteStudentEvent(_studentAddress, _studentId);
    }
}
