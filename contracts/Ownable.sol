// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title Ownable
 * @dev add and modify admin privileges
 */
contract Ownable {

    address owner;

    constructor() {
        require(msg.sender != address(0), 'deployer cannot be addr 0');
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, 'caller not owner');
        _;
    }

    modifier notAddressZero(address newOwner) {
        require(newOwner != address(0), 'new owner cannot be address zero');
        _;
    }

    function changeOwner(address newOwner) public onlyOwner() notAddressZero(newOwner) {
        owner = newOwner;
    }
}