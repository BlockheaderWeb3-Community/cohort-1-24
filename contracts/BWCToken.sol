// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title BWCContract
 * @dev Basic ERC20 Token implementation with additional functionality.
 */
contract BWCContract {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => mapping(address => bool)) private _isAproveAll;

    error InsuficientBalance(
        address from,
        address to,
        uint256 value,
        string message
    );
    error ERC20InvalidAccount(address account, string message);
    error Unauthorised(string message);
    error InvalidAmount(string message);

    event Approval(address indexed owner, address spender, uint256 value);

    /**
     * @dev Initializes the contract with initial parameters.
     * @param name_ The name of the token.
     * @param symbol_ The symbol of the token.
     * @param decimals_ The number of decimals used in the token representation.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    /**
     * @dev Returns the name of the token.
     * @return The name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token.
     * @return The symbol of the token.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used in the token representation.
     * @return The number of decimals used in the token representation.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the balance of the specified address.
     * @param _account The address to query the balance of.
     * @return The balance of the specified address.
     */
    function balance(address _account) public view returns (uint256) {
        return _balances[_account];
    }

    /**
     * @dev Transfers tokens from sender's account to another account.
     * @param _to The address to transfer tokens to.
     * @param _value The amount of tokens to transfer.
     * @return A boolean indicating whether the transfer was successful or not.
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        address from = msg.sender;
        if (from == address(0)) {
            revert ERC20InvalidAccount(from, "Sender is address 0");
        }
        if (_to == address(0)) {
            revert ERC20InvalidAccount(_to, "Recipient is address 0");
        }
        if (_value == 0) {
            revert InvalidAmount("Value is 0");
        }
        uint256 fromBalance = _balances[from];
        if (_value >= fromBalance) {
            revert InsuficientBalance(
                from,
                _to,
                _value,
                "Insufficient balance"
            );
        }

        _balances[from] -= _value;
        _balances[_to] += _value;

        return true;
    }

    /**
     * @dev Mints new tokens and assigns them to the specified address.
     * @param _to The address to which new tokens will be minted.
     * @param _value The amount of tokens to mint.
     */
    function mint(address _to, uint256 _value) public {
        address from = msg.sender;
        if (from == address(0)) {
            revert ERC20InvalidAccount(from, "Sender is address zero");
        }
        if (_to == address(0)) {
            revert ERC20InvalidAccount(_to, "Recipient is address zero");
        }
        if (_value == 0) {
            revert InvalidAmount("Value is zero");
        }

        _totalSupply += _value;
        _balances[_to] -= _value; // Should be += instead of -=
    }

    /**
     * @dev Approves the specified address to transfer tokens on behalf of the owner.
     * @param _owner The address which owns the tokens.
     * @param _spender The address which will transfer the tokens.
     * @param _value The amount of tokens to be transferred.
     */
    function approve(
        address _owner,
        address _spender,
        uint256 _value
    ) public {
        if (_owner == address(0) || _spender == address(0)) {
            revert ERC20InvalidAccount(address(0), "Invalid account address");
        }

        uint256 ownerBalance = _balances[_owner];

        if (_value > ownerBalance) {
            revert InsuficientBalance(
                _owner,
                _spender,
                _value,
                "Insufficient owner balance"
            );
        }
        _allowances[_owner][_spender] = _value;
        emit Approval(_owner, _spender, _value);
    }

    /**
     * @dev Transfers tokens from one address to another on behalf of a token holder.
     * @param _from The address which tokens will be transferred from.
     * @param _to The address which tokens will be transferred to.
     * @param _value The amount of tokens to be transferred.
     */
    function tranferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public {
        address spender = msg.sender;
        uint256 allowance = _allowances[_from][spender];

        if (_from == address(0) || _to == address(0)) {
            revert ERC20InvalidAccount(address(0), "Invalid account address");
        }

        if (allowance == 0) {
            revert Unauthorised(
                "You've not been authorized to perform this transaction"
            );
        }

        if (_value > allowance) {
            revert InsuficientBalance(
                _from,
                _to,
                _value,
                "Insufficient allowance"
            );
        }

        uint256 newValue = allowance - _value;
        _allowances[_from][spender] = newValue;

        _balances[_from] -= _value;
        _balances[_to] += _value;
    }

    /**
 * @dev Allows `_owner` to approve or disapprove `_spender` to transfer all of their tokens.
 * @param _spender The address which will spend the funds.
 * @param _canTransfer Boolean indicating whether `_spender` is allowed to transfer all tokens on behalf of `_owner`.
 * @return  boolean indicating whether the operation was successful.
 */
function approveAll(address _spender, bool _canTransfer)
    public
    returns (bool)
{
    address _owner = msg.sender;

    // Ensure neither the owner nor the spender address is zero.
    if (_owner == address(0) || _spender == address(0)) {
        revert ERC20InvalidAccount(address(0), "Invalid account address");
    }

    // Update the approval status for _spender by _owner.
    _isAproveAll[_owner][_spender] = _canTransfer;

    // Return true indicating the operation was successful.
    return true;
}

}
