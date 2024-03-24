// SPDX-License-Identifier: MIT

<<<<<<< HEAD
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
=======
pragma solidity >=0.8.2 < 0.9.0;

import {SimpleCounter} from "./SimpleCounter.sol";
import {StudentRegistry} from "./StudentRegistry.sol";
import {Ownable} from "./Ownable.sol";
>>>>>>> 2618822497e7d49990c48a62fe54ee9942370651

contract FactoryContract is Ownable {
    SimpleCounter public simpleCounter;
    StudentRegistry public  studentRegistry;

    constructor() {
        creatInstance();
    }

    function creatInstance() private  onlyOwner {
        simpleCounter = new SimpleCounter();
        studentRegistry = new StudentRegistry();

    
    }


<<<<<<< HEAD
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
=======
>>>>>>> 2618822497e7d49990c48a62fe54ee9942370651
}