// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;


contract SimpleCounterLogs {
    // Event emitted when the 'store' function is called
    event valueAlteration(address indexed sender, uint256 count);


    event underCountAlteration(address indexed sender, int256 count);


    
}