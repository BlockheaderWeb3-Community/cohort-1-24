// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;
import "hardhat/console.sol";

/**
 * @title ETHBankContract
 * @dev send and receive ETH
 */

contract ETHBankContract {
    address public owner;
    mapping(address => uint256) public ethBalances;

    event Deposit(address _address, uint256 _amount, uint256 _prevBalance, uint256 _currentBalance);
    event Withdraw(address _address, uint256 _amount, uint256 _prevBalance, uint256 _currentBalance);
    event WithdrawAll(address _address, uint256 _amount, uint256 _prevBalance, uint256 _currentBalance);
    event EmergencyWithdraw(address _address, uint256 _amount, uint256 _prevBalance, uint256 _currentBalance);


    constructor() {
        owner = msg.sender;
    }

    function depositETH() public payable {
        uint256 balanceBefore = ethBalances[msg.sender];
        uint256 ethAmount = msg.value;
        require(ethAmount != 0, "you must add ETH");
        ethBalances[msg.sender] += ethAmount;
        (bool success, ) = address(this).call{value: ethAmount}("");
        require(success, "failed to deposit ETH");
        emit Deposit(msg.sender, ethAmount, balanceBefore, ethBalances[msg.sender]);
    }

    /**
     * @dev Allows users to withdraw their ETH balance from the contract.
     */
    function withdrawETH(uint256 amount) public {
        uint256 balanceBefore = ethBalances[msg.sender];
        require(amount > 0, "amount to withdraw must be greater than 0");
        require(amount <= balanceBefore, "insufficient balance");
        ethBalances[msg.sender] -= amount;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "failed to withdraw ETH");
        emit Withdraw(msg.sender, amount, balanceBefore, ethBalances[msg.sender]);
    }

    function withdrawAllETH() public {
        uint256 balanceBefore = ethBalances[msg.sender];
        require(balanceBefore != 0, "insufficient balance");
        uint256 amountToWithdraw = ethBalances[msg.sender];
        ethBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "failed to withdraw all ETH");
        emit WithdrawAll(msg.sender, amountToWithdraw, balanceBefore, ethBalances[msg.sender]);
    }

    function getContractEthBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function ownerOnlyWithdraw() public {
        require(msg.sender == owner, "only owner can call emergency withdraw");
        uint256 balanceBefore = ethBalances[owner];
        uint256 contractBalance = getContractEthBalance();
        ethBalances[owner] = contractBalance;
        (bool success, ) = owner.call{value: contractBalance}("");
        require(success, "failed to withdraw all ETH to owner");
        emit EmergencyWithdraw(owner, contractBalance, balanceBefore, ethBalances[owner]);
    }

    receive() external payable {
        console.log("RECEIVE: ETH received now as depositETH fn is called");
    }
}
