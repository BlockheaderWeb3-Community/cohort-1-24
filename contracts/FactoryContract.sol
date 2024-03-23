// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
import {SimpleCounter} from "./SimpleCounter.sol";
import {Ownable} from "./Ownable.sol";

/**
 * @title FactoryContract
 * @dev deploy other contracts
 */

contract FactoryContract is Ownable{

    SimpleCounter public simpleCounter;

   // event CountIncreased( address indexed caller );
   // event ContractCreated( address indexed creator);

    constructor() {
        createSimpleCounterContract();
    }

    function createSimpleCounterContract() public onlyOwner() {
        simpleCounter = new SimpleCounter();
    //    emit ContractCreated(msg.sender);
        
    }
    
    function callIncreaseCount() public onlyOwner() {
        simpleCounter.increaseCount{}
   //     emit CountIncreased(msg.sender);
    }

    function callRetrieve() public view returns(uint256){
        return simpleCounter.retrieve();
    } 
}