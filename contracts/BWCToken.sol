// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title BWCToken
 * @dev Basic ERC20 token contract with custom error handling and events as per ERC-20 standard.
 * @custom:ca - 0xeCbe3cFEF7224E7913cB851ada2eB01CA91e7D3b
 */
interface IERC20 {
    /**
     * @dev Returns the remaining number of tokens that spender will be allowed to spend on behalf of owner through `transferFrom`.
     * @param owner The address which owns the funds.
     * @param spender The address which will spend the funds.
     * @return The number of tokens still available for the spender.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     * @param spender The address which will spend the funds.
     * @param amount The amount of tokens to allow.
     * @return A boolean value indicating whether the operation succeeded.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the allowance mechanism. `amount` is then deducted from the caller's allowance.
     * @param sender The address which owns the funds.
     * @param recipient The address which will receive the funds.
     * @param amount The amount of tokens to transfer.
     * @return A boolean value indicating whether the operation succeeded.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

contract BWCToken {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    /**
     * @dev Emitted when tokens are transferred from one address to another.
     */
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /**
     * @dev Emitted when the allowance of a spender for an owner is set by a call to `approve`.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /**
     * @dev Emitted when tokens are minted to `to`.
     */
    event Mint(address indexed to, uint256 amount);

    /**
     * @dev Error for zero address.
     * @param _address The address causing the error.
     * @param _message The error message.
     */
    error ZeroAddress(address _address, string _message);

    /**
     * @dev Error for insufficient balance.
     * @param _balance The balance of the sender.
     * @param _amount The amount being sent.
     * @param _message The error message.
     */
    error InsufficientBalance(
        uint256 _balance,
        uint256 _amount,
        string _message
    );

    /**
     * @dev Error for zero mint.
     * @param _amount The amount of tokens to mint.
     * @param _message The error message.
     */
    error ZeroMint(uint256 _amount, string _message);

    /**
     * @dev Constructor to initialize the token contract.
     * @param name_ The name of the token.
     * @param symbol_ The symbol of the token.
     * @param decimals_ The number of decimals the token uses.
     */
    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals the token uses.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the total supply of the token.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns the balance of the specified address.
     * @param account The address to query the balance of.
     */
    function balanceOf(address account) public view returns (uint256 balance) {
        balance = _balances[account];
    }

    /**
     * @dev Returns the allowance of one address to another.
     * @param owner The address which owns the funds.
     * @param spender The address which will spend the funds.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     * @param spender The address which will spend the funds.
     * @param amount The amount of tokens to allow.
     * @return A boolean value indicating whether the operation succeeded.
     */
    function approve(address spender, uint256 amount) external returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     * @param to The address which will receive the funds.
     * @param amount The amount of tokens to transfer.
     * @return A boolean value indicating whether the operation succeeded.
     */
    function transfer(address to, uint256 amount) public returns (bool) {
        address from = msg.sender;

        if (from == address(0)) {
            revert ZeroAddress(from, "Sender is zero address");
        }

        if (to == address(0)) {
            revert ZeroAddress(to, "Receiver is zero address");
        }

        uint256 fromBalance = _balances[from];

        if (fromBalance < amount) {
            revert InsufficientBalance(
                fromBalance,
                amount,
                "Insufficient balance"
            );
        }

        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Moves `amount` tokens from the sender's account to `recipient`.
     * @param sender The address sending the funds.
     * @param recipient The address which will receive the funds.
     * @param amount The amount of tokens to transfer.
     * @return A boolean value indicating whether the operation succeeded.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        if (sender == address(0)) {
            revert ZeroAddress(sender, "Sender is zero address");
        }

        if (recipient == address(0)) {
            revert ZeroAddress(recipient, "Recipient is zero address");
        }

        uint256 senderBalance = _balances[sender];
        if (amount > senderBalance) {
            revert InsufficientBalance(
                senderBalance,
                amount,
                "Transfer amount exceeds sender balance"
            );
        }

        uint256 allowedAmount = _allowances[sender][msg.sender];
        if (amount > allowedAmount) {
            revert InsufficientBalance(
                allowedAmount,
                amount,
                "Transfer amount exceeds allowance"
            );
        }

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        _allowances[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    /**
     * @dev Mints `amount` tokens and assigns them to `to`.
     * @param to The address which will receive the minted tokens.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) public {
        if (msg.sender == address(0)) {
            revert ZeroAddress(msg.sender, "Sender is zero address");
        }

        if (to == address(0)) {
            revert ZeroAddress(to, "Receiver is zero address");
        }

        if (amount == 0) {
            revert ZeroMint(amount, "Value is zero");
        }

        _totalSupply += amount;
        _balances[to] += amount;

        emit Mint(to, amount);
    }
}
