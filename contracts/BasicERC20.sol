// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

// Basic ERC20 token contract
contract BWCContract {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256 balance) {
        balance = _balances[account];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        address from = msg.sender;
        require(from != address(0), "Sender is zero address");
        require(to != address(0), "Receiver is zero address");
        require(value != 0, "Value is zero");

        uint256 fromBalance = _balances[from];

        require(fromBalance >= value, "Insufficient balance");

        _balances[from] -= value;
        _balances[to] += value;

        return true;
    }  

    function mint(address to, uint256 value) public {
        address from = msg.sender;
        require(from != address(0), "Sender is zero address");
        require(to != address(0), "Receiver is zero address");
        require(value != 0, "Value is zero");

        _totalSupply += value;
        _balances[to] += value;
    }
}


// ASSIGNMENT (30/03/2024)
// 1. Convert all require statements to custom errors (https://docs.soliditylang.org/en/v0.8.25/contracts.html#errors-and-the-revert-statement)
// 2. Document the code using NatSpec format (https://docs.soliditylang.org/en/v0.8.25/natspec-format.html)
// 3. Add events to contract as required by the token standard specified here: https://eips.ethereum.org/EIPS/eip-20
// 4. After 1, 2, and 3 have been completed, deploy your token to Sepolia testnet using either Remix IDE or Hardhat 
//    and send contract address to #assignment channel on discord. Example token contract address on Sepolia: https://sepolia.etherscan.io/token/0x7ce4DacfD778cAac416899F31638F9abbC072AAE
