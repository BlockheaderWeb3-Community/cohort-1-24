// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 < 0.9.0;

import {SimpleCounter} from "./SimpleCounter.sol";
import {StudentRegistry} from "./StudentRegistry.sol";
import {Ownable} from "./Ownable.sol";

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


}