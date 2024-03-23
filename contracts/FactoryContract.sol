// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import { SimpleCounter } from "./SimpleCounter.sol";
import { Ownable } from "./Ownable.sol";

/**
*@title FactoryContract
*@dev deploy other contracts
**/

contract FactoryContract is Ownable {

    //reference SimpleCounter contract    
    SimpleCounter public simpleCounter; //type visibiity varaible_name
    //reference Ownable contract 
    Ownable public ownable; //type visibiity varaible_name

    constructor () {
        createSimpleCounterContract();
        createOwnableContract();
    }

    event ownableEvent(address Owner, string message);
    event simpleCounterEvent(address caller, string anotherMessage);

    // modifier onlyOwner() {
    //     require(msg.sender == Owner, "caller not owner");
    //     _;
    // }

    function createOwnableContract() public {
       ownable = new Ownable(); // deploys ownable contract
       
       //emitting event for the ownable contract
       emit ownableEvent(msg.sender, "ownable contract has been deployed");
    }

    function createSimpleCounterContract() public onlyOwner(){
        
        simpleCounter = new SimpleCounter(); // deploys simple counter
        //emitting event for simple counter
        emit simpleCounterEvent(msg.sender, "simpleCounterContract has been deployed");
    }

    function callIncreaseCount() public onlyOwner(){
        simpleCounter.increaseCount();
    }

    function callRetrieve() public view returns (uint){
        return simpleCounter.retrieve();
    }


}