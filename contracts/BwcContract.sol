// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract BWCContract {
    string private _name;
    string private _symbol;
    uint8 private _decimal;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowance;
    mapping(address => mapping(address => bool)) private spendAll;

    error InsufficientBalance(address from, address to, uint256 value);
    error InvalidAddress(address invalidAddress);

    constructor(string memory name_, string memory symbol_, uint8 decimal_) {
        _name = name_;
        _symbol = symbol_;
        _decimal = decimal_;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimal;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256 balance) {
        balance = _balance[account];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        address from = msg.sender;
        if (from == address(0)) {
            revert InvalidAddress(from);
        }
        if (to == address(0)) {
            revert InvalidAddress(to);
        }
        if (value == 0) {
            revert InsufficientBalance(from, to, value);
        }

        uint256 fromBalance = _balance[from];
        if (fromBalance < value) {
            revert InsufficientBalance(from, to, value);
        }

        _balance[from] -= value;
        _balance[to] += value;
        
        return true;
    }

    function mint(address to, uint256 value) public {
        address from = msg.sender;
        if (from == address(0)) {
            revert InvalidAddress(from);
        }
        if (to == address(0)) {
            revert InvalidAddress(to);
        }
        if (value == 0) {
            revert InsufficientBalance(from, to, value);
        }

        _totalSupply += value;
        _balance[to] += value;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        _allowance[msg.sender][_spender] = _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        if (_to == address(0)) {
            revert InvalidAddress(_to);
        }
        if (_from == address(0)) {
            revert InvalidAddress(_from);
        }
        if (_value > _balance[_from]) {
            revert InsufficientBalance(_from, _to, _value);
        }
        if (_value > _allowance[_from][msg.sender]) {
            revert InsufficientBalance(_from, _to, _value);
        }

        _balance[_from] -= _value;
        _balance[_to] += _value;
        _allowance[_from][msg.sender] -= _value;
    
        return true;
    }

    function approveAll(address _spender, bool canTransfer) public returns (bool) {
        address _owner = msg.sender;
        if (_spender == address(0)) {
            revert InvalidAddress(_spender);
        }
        spendAll[_owner][_spender] = canTransfer;
        return true;
    }
}
