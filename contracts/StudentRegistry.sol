// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title StudentRegistry
 * @dev create students & retrieve already-created students
 */
contract StudentRegistry {
    address public admin;

    struct Student {
        uint8 studentId;
        string name;
        uint8 age;
        bool isActive;
        bool isPunctual;
    }

    event StudentInformation(
        uint256 studentId,
        string name,
        uint256 age,
        bool isActive,
        bool isPunctual
    );

    mapping(address => Student) public studentsMapping;
    mapping(uint256 => bool) public keyExists;

    Student[] public listOfStudents;

    //  * @dev Set contract deployer as admin
    //  */
    constructor() {
        admin = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
    }

    modifier onlyOwner() {
        require(msg.sender == admin, "caller not owner");
        _;
    }

    function addStudent(
        address studentAddress,
        uint8 _studentId,
        string memory _name,
        uint8 _age,
        bool _isActive,
        bool _isPunctual
    ) external {
        require(msg.sender == admin, "only admin can add student");
        // validate inputs
        require(_studentId != 0, "please provide valid ID");
        require(bytes(_name).length != 0, "name length must be >= 3");
        require(_age >= 18, "you must not be underage");
        Student memory student;

        // instantiate student struct
        student.studentId = _studentId;
        student.name = _name;
        student.age = _age;
        student.isActive = _isActive;
        student.isPunctual = _isPunctual;

        // map student struct as value to the passed-in address as key
        // this ensures that one can retrieve a student profile by passing in an address
        studentsMapping[studentAddress] = student;

        // add new student to the array of Student array of struct
        listOfStudents.push(student);
    }

    function getStudentByAddress(address studentAddress)
        public
        view
        returns (Student memory)
    {
        return studentsMapping[studentAddress];
    }

    function getTotalNumberOfStudents() public view returns (uint256) {
        return listOfStudents.length;
    }

    function getStudentFromListOfStudentsArray(uint256 studentIndex)
        public
        view
        returns (Student memory)
    {
        return listOfStudents[studentIndex];
    }

    function getListOfStudents() public view returns (Student[] memory) {
        Student[] memory newListOfStudents = new Student[](
            listOfStudents.length
        );
        for (uint256 i = 0; i < listOfStudents.length; i++) {
            newListOfStudents[i] = listOfStudents[i];
        }

        return newListOfStudents;
    }

    // function studentExistInMapping(address studentAddress) public onlyOwner returns (bool) {

    //   return   studentsMapping[studentAddress];
    // }

    function isStudentIdInList(uint8 _studentId)
        private
        view
        onlyOwner
        returns (bool)
    {
        for (uint256 i = 0; i < listOfStudents.length; i++) {
            if (listOfStudents[i].studentId == _studentId) return true;
        }

        return false;
    }

    function isStudentInMapping(address _studentAddress)
        public
        view
        onlyOwner
        returns (bool)
    {

        if(studentsMapping[_studentAddress].studentId != 0){
            return  true;
        }

        return false;
    }

    function studentNotFound() private pure returns (string memory) {
        return "Student not found";
    }

    //Delete from array

    function deleteStudentFromArray(uint8 studentId) public onlyOwner {
        if (isStudentIdInList(studentId)) {
            Student memory student = Student({
                studentId: 0,
                name: "",
                age: 0,
                isActive: false,
                isPunctual: false
            });
            listOfStudents[studentId] = student;
        } else {
            studentNotFound();
        }
    }


//Delete from mapping


function deleteStudentFromMapping(address _studentAddress) public onlyOwner {
        if (isStudentInMapping(_studentAddress)) {
            Student memory student = Student({
                studentId: 0,
                name: "",
                age: 0,
                isActive: false,
                isPunctual: false
            });
            studentsMapping[_studentAddress] = student;
        } else {
            studentNotFound();
        }
    }
}
