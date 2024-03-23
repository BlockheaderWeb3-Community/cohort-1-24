// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
import { SimpleCounter } from "./SimpleCounter.sol";
import { Ownable } from "./Ownable.sol";

/**
 * @title FactoryContract
 * @dev deploy other contracts 
 */
contract FactoryContract {
	// Define an event
    event SimpleCounterContractCreated(address indexed creator, address simpleCounterAddress);

    // reference SimpleCounter contract
    SimpleCounter public simpleCounter; // type visibility variable name

    constructor () {
        createSimpleCounterContract();
    }


    function createSimpleCounterContract() public onlyOwner {
        simpleCounter = new SimpleCounter(); // deploys simple counter
		// Emit the event
        emit SimpleCounterContractCreated(msg.sender, address(simpleCounter));
    }

    function callIncreaseCount() public onlyOwner {
        simpleCounter.increaseCount();
    }

    function callRetrieve() public view returns(uint256) onlyOwner {
        return simpleCounter.retrieve();
    }
}