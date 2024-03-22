// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;
import {ValidateStudent} from "./ValidateStudent.sol";
import {Ownable} from "./Ownable.sol";

contract StudentLogs {

    event StudentAction(
        address indexed studentAddress,
        uint256 studentId,
        string name,
        uint8 age,
        bool isActive,
        bool isPunctual
    );


    event StudentDeleted(
        address indexed studentAddress,
        uint256 studentId
    );
}
