// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
import { IJustCounter } from "./IJustCounter.sol";

/**
 * @title ImplementAllContract
 * @dev implement increase and decrease function using interface
 */
contract ImplementAllContract {
      IJustCounter public iJustCounter;

      constructor(address _iJustCounter) {
        iJustCounter = IJustCounter(_iJustCounter);
      }

      function newIncreaseCount() public {
        iJustCounter.increaseCount();
      }


      function fetchCount() public view returns(uint256){
        return iJustCounter.retrieve();

      }
}