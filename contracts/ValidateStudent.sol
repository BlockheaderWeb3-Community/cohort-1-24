// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract ValidateStudent {

    modifier isStudentDataValid(string memory _name, uint256 _age) {
        require(bytes(_name).length != 0, "name length must be >= 3");
        require(_age >= 18, "you must not be underage");

        _;
    }


    // modifier studentExists(address _studentAddress, uint256 _studentId) {
    //     require(studentRegistry.studentsMap[_studentAddress][_studentId].studentId != 0, "Student does not exist");
    //     _;
    // }
}
