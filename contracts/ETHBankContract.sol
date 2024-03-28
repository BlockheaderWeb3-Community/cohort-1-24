// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;
import "hardhat/console.sol";

/**
 * @title ETHBankContract
 * @dev Send and receive ETH 
 */
contract ETHBankContract {
    address public owner;
    mapping(address => uint256) public ethBalances;
    uint256 public totalDeposits;

    constructor() {
        owner = msg.sender;
    }

    function depositETH() public payable {
        uint256 ethAmount = msg.value;
        require(ethAmount != 0, "You must add ETH");
        ethBalances[msg.sender] += ethAmount;
        totalDeposits += ethAmount;
        console.log("ETH deposited successfully");
    }

    function withdrawETH(uint256 amount) public {
        require(ethBalances[msg.sender] >= amount, "Insufficient balance");
        ethBalances[msg.sender] -= amount;
        totalDeposits -= amount;
        if (ethBalances[msg.sender] == 0) {
            // If the user withdraws their entire balance, bar them from further withdrawals
            ethBalances[msg.sender] = type(uint256).max;
        }
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw ETH");
    }

    function ownerOnlyWithdraw() public {
        require(msg.sender == owner, "Only owner can call emergency withdraw");
        uint256 contractBalance = getContractEthBalance();
        totalDeposits = 0;
        (bool success, ) = owner.call{value: contractBalance}("");
        require(success, "Failed to withdraw all ETH to owner");
    }

    function getContractEthBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getEthBalance() public view returns (uint256) {
        if (msg.sender == owner) {
            return totalDeposits;
        } else {
            return ethBalances[msg.sender];
        }
    }

    receive() external payable {
        console.log("RECEIVE: ETH received, depositETH function is called");
    }
}
