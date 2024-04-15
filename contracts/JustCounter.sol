// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title SimpleCounter
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract JustCounter {

    uint256 public count;
    int256 public underCount;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        count = num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns(uint256) {
        return count;
    }


    function increaseCount() public {
        count += 1;
    }

    function decreaseCount() public  {
        count -= 1;
    }

    function isCountEven() public view returns (bool) {
        uint256 currentCount = retrieve();
        if (currentCount % 2 == 0) return true;
        return false;
    }


    function increaseUnderCount() public {
       underCount += 1;
    }

    function decreaseUnderCount() public {
       underCount -= 1;
    }

    function getUnderCount() public view returns (int256){
        return underCount;
    }    
}