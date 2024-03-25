// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

// Imports
import {ValidateStudent} from "./ValidateStudent.sol";
import {Ownable} from "./Ownable.sol";
import {StudentLogs} from "./StudentRegistryLogs.sol";

contract StudentRegistry is ValidateStudent, Ownable, StudentLogs {
    uint256 public studentsCounter;

    struct Student {
        uint256 studentId;
        string name;
        uint8 age;
        bool isActive;
        bool isPunctual;
    }

    mapping(address => mapping(uint256 => Student)) public studentsMap;

    // Function to add a new student
    function addStudent(
        address _studentAddress
        string memory _name,
        uint8 _age,
        bool _isActive,
        bool _isPunctual
    )
        external
        isStudentDataValid(_name, _age)
        onlyOwner
        notAddressZero(_studentAddress)
    {
        studentsCounter++;
        uint256 studentId = studentsCounter;

        Student memory student = Student(
            studentId,
            _name,
            _age,
            _isActive,
            _isPunctual
        );
        studentsMap[_studentAddress][studentId] = student;

        // Emit event for adding a student
        emit StudentAction(
            _studentAddress,
            studentId,
            _name,
            _age,
            _isActive,
            _isPunctual
        );
    }

    // Function to update an existing student
    function updateStudent(
        address _studentAddress,
        uint256 _studentId,
        string memory _name,
        uint8 _age,
        bool _isActive,
        bool _isPunctual
    )
        external
        isStudentDataValid(_name, _age)
        onlyOwner
        notAddressZero(_studentAddress)
    {
        Student memory student = Student(
            _studentId,
            _name,
            _age,
            _isActive,
            _isPunctual
        );
        studentsMap[_studentAddress][_studentId] = student;

        // Emit event for updating a student
        emit StudentAction(
            _studentAddress,
            _studentId,
            _name,
            _age,
            _isActive,
            _isPunctual
        );
    }

    // Function to retrieve student details by address and ID
    function getStudentDetails(
        address _studentAddress,
        uint256 _studentId
    ) public view notAddressZero(_studentAddress) returns (Student memory) {
        return studentsMap[_studentAddress][_studentId];
    }

    // Function to delete a student
    function deleteStudent(
        address _studentAddress,
        uint256 _studentId
    ) public onlyOwner notAddressZero(_studentAddress) {
        delete studentsMap[_studentAddress][_studentId];
        // Emit event for deleting a student
        studentsCounter--;
        emit StudentDeleted(_studentAddress, _studentId);
    }
}
