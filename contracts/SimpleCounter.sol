// trustless - no need for 3rd parties
// decentralized
// distributed
// permissionless
// secure
// immutable


// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
import { Ownable } from "./Ownable.sol";

/**
 * @title SimpleCounter
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract SimpleCounter is Ownable {

    uint256 count;

    int256 underCount;

    //all event declaration
    event eventForStore(address caller, string message);
    event decreaseCountEvent(address owner, string anodMessage);
    event increaseCountEvent(address own, string anotherMessage);
    event decreaseUnderCountEvent(address underCountOwn2, string underCountMesge);


    function store(uint256 num) public onlyOwner() {
        count = num;

        //emitting event for stored number
         emit eventForStore(msg.sender, "number has been stored");
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns(uint256) {
        return count;
    }


    function increaseCount() public onlyOwner() {
        count += 1;

        //emitting event for increase count
        emit increaseCountEvent(msg.sender, "count is increased by 1");
    }

    function decreaseCount() public onlyOwner() {
        count -= 1;

        //emitting event for decrease count
        emit decreaseCountEvent(msg.sender, "count is decreased by 1");
    }

    function isCountEven() public view returns (bool) {
        uint256 currentCount = retrieve();
        if (currentCount % 2 == 0) return true;
        return false;
    }

    function increaseUnderCount() public onlyOwner() {
        underCount += 1;
        
        // emitting increase underCount Event    
        emit increaseCountEvent(msg.sender, "UnderCount is increased by 1");
    }

    function decreaseUnderCount() public onlyOwner() {
        underCount -= 1;

        // emiting decrease UnderCount Event
        emit decreaseUnderCountEvent(msg.sender, "UnderCount is decreased by 1");
    }

    function getUnderCount() public view returns (int256){
        return underCount;
    }

    function isOwner() public view returns(bool) {
       address currentOwner = getCurrentOwner();
       if(currentOwner == owner) return true;
       return false;
    }

    function whoIsOwner() public view returns (address) {
            return getCurrentOwner();
    }
    
}