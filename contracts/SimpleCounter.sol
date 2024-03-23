
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
    function retrieve() public view returns (uint256) {
        return count;
    }

    function increaseCount() public onlyOwner {
        count += 1;
        emit valueAlteration(msg.sender, count);
    }

    function decreaseCount() public onlyOwner {
        count -= 1;
    }

    function isCountEven() public view returns (bool) {
        uint256 currentCount = retrieve();
        if (currentCount % 2 == 0) return true;
        return false;
    }

    function increaseUnderCount() public onlyOwner {
        underCount += 1;
        emit underCountAlteration(msg.sender, underCount);
    }

    function decreaseUnderCount() public onlyOwner {
        underCount -= 1;
        emit underCountAlteration(msg.sender, underCount);
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
}
