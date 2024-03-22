// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;
import {Ownable} from "../contracts/Ownable.sol";

contract StudentEvents {
    event AddOrUpdateStudentEvent(
        address indexed studentAddress,
        uint256 studentId,
        string name,
        uint8 age,
        bool isActive,
        bool isPunctual
    );

    event DeleteStudentEvent(address indexed studentAddress, uint256 studentId);
}
