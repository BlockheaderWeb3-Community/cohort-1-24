// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
import {Ownable} from "./Ownable.sol";
import {SimpleCounter} from "./SimpleCounter.sol";
import {StudentRegistry} from "./StudentRegistry.sol";

/**
 * @title FactoryContract
 * @dev deploy other contracts
 */
contract FactoryContract is Ownable {
    // reference SimpleCounter contract
    SimpleCounter public simpleCounter; // type visibility variable name
    StudentRegistry public studentRegistry;

    constructor() {
        initializeContracts();
    }

    function initializeContracts() private onlyOwner {
        simpleCounter = new SimpleCounter();
        studentRegistry = new StudentRegistry();
    }
}
