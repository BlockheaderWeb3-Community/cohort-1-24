// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
import "hardhat/console.sol";
/**
 * @title ETHBankContract
 * @dev send and receive ETH  
 */

contract ETHBankContract {
    address owner;
    mapping(address => uint256) public ethBalances;

    constructor() {
        owner = msg.sender;
    }
    
    function depositETH() public payable {
        uint256 ethAmount = msg.value;
        require(ethAmount != 0, 'you must add ETH');
        (bool success, ) = address(this).call{value: ethAmount}("");
        console.log("txn success here:____", success);
        require(success, "failed to deposit ETH");
        ethBalances[msg.sender] += ethAmount;
    }

    function getContractEthBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function ownerOnlyWithdraw() public {
        require(msg.sender ==  owner, 'only owner can call emergency withdraw');
       uint256 contractBalance = getContractEthBalance();
        (bool success, ) = owner.call{value: contractBalance}("");
        require(success, "failed to withdraw all ETH to owner");
    }

    receive() external payable {
        console.log("RECEIVE: ETH received now as depositETH fn is called");
    }   
}