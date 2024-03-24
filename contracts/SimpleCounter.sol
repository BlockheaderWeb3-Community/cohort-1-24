
// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
import {Ownable} from "./Ownable.sol";
import {SimpleCounterLogs} from "./SimpleCounterLogs.sol";

/**
 * @title SimpleCounter
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract SimpleCounter is Ownable, SimpleCounterLogs {
    uint256 count;

    int256 underCount;

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public onlyOwner {
        count = num;
    }

    /**
     * @dev Return value
     * @return value of 'number'
     */
<<<<<<< HEAD
    function retrieve() public view onlyOwner returns(uint256) {
        return count;
    }


=======
    function retrieve() public view returns (uint256) {
        return count;
    }

>>>>>>> 2618822497e7d49990c48a62fe54ee9942370651
    function increaseCount() public onlyOwner {
        count += 1;
        emit valueAlteration(msg.sender, count);
    }

<<<<<<< HEAD
    function decreaseCount() public  onlyOwner {
=======
    function decreaseCount() public onlyOwner {
>>>>>>> 2618822497e7d49990c48a62fe54ee9942370651
        count -= 1;
    }

    function isCountEven() public view returns (bool) {
        uint256 currentCount = retrieve();
        if (currentCount % 2 == 0) return true;
        return false;
    }

<<<<<<< HEAD

    function increaseUnderCount() public onlyOwner {
       underCount += 1;
    }
 
    function decreaseUnderCount() public onlyOwner {
       underCount -= 1;
=======
    function increaseUnderCount() public onlyOwner {
        underCount += 1;
        emit underCountAlteration(msg.sender, underCount);
    }

    function decreaseUnderCount() public onlyOwner {
        underCount -= 1;
        emit underCountAlteration(msg.sender, underCount);
>>>>>>> 2618822497e7d49990c48a62fe54ee9942370651
    }

    function getUnderCount() public view returns (int256) {
        return underCount;
    }

    function isOwner() public view returns (bool) {
        address currentOwner = getCurrentOwner();
        if (currentOwner == owner) return true;
        return false;
    }

    function whoIsOwner() public view returns (address) {
        return getCurrentOwner();
    }
<<<<<<< HEAD
    
}
=======
}
>>>>>>> 2618822497e7d49990c48a62fe54ee9942370651
