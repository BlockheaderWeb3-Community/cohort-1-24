// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
import { SimpleCounter } from "./SimpleCounter.sol";

/**
 * @title FactoryContract
 * @dev deploy other contracts 
 */
contract FactoryContract {
    // reference SimpleCounter contract
    SimpleCounter public simpleCounter; // type visibility variable name

    constructor () {
        createSimpleCounterContract();
    }


    function createSimpleCounterContract() public {
        simpleCounter = new SimpleCounter(); // deploys simple counter
    }

    function callIncreaseCount() public {
        simpleCounter.increaseCount();
    }

    function callRetrieve() public view returns(uint256) {
        return simpleCounter.retrieve();
    }
}