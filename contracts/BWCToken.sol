// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BWCContract{
    string private _name;
    string private _symbol;
    uint8 private _decimal;
    uint256 private _totalSupply;

    // mapping to get the balance tired to a specific address
    mapping(address => uint256) private _balance;

    //this mapping is used to track the allowance given to any account to spend from another account 
    mapping(address => mapping (address => uint256)) private _allowance;

    //this mapping allows the spender we pass in to spend all or transfer all the balance
    mapping(address => mapping (address => bool)) private _spendAll;


    //all event declarations
    event transferEvt(address caller, address to, uint256 amount);
    event mintEvt(address caller, address to, uint256 amount);
    event approveEvt(address caller, address spender, uint256 currentValue, uint256 value);
    event transferFromEvt(address caller, address from, address to, uint256 value);
    event approveAllEvt(address caller, address sender, bool canTransfer);

    //custom error declaration
    error InsufficientBalance(uint256 available, uint256 required);
    error InvalidAddress(string);
    error valueTooSmall(string);
    error InvalidAllowance(string);

    constructor(string memory name_, string memory symbol_, uint8 decimal_){
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

    function decimals() public view returns (uint8){
        return _decimal;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }


    function balanceOf(address account) public view returns (uint256 balance){
        balance = _balance[account];
    }


    function mint(address to, uint256 value) public {
        //assigning the msg.sedender/caller to a variable 'from'
        address from = msg.sender;
        //ensuring address from is not address zero
        if(from == address(0)) {
            revert InvalidAddress("address from can't be an address zero");
        }
        //ensuring address to is not a zero adddress
        if(to == address(0)) {
            revert InvalidAddress("to can't be an address zero");
        }
        //ensuring amount/value being minted is more than zero
        if(value <= 0) {
            revert valueTooSmall("can only mint more than zero amount");
        }

        //this is where minting is performed 
        _totalSupply += value;
        _balance[to] += value;

        emit mintEvt(msg.sender, to, value);
    }
    
    function transfer(address to, uint256 value) public returns (bool) {
        //assigning the msg.sedender/caller to a variable 'from'
        address from = msg.sender;

        //ensuring the caller(from) is not address zero
        if(from == address(0)) {
            revert InvalidAddress("from can't be Address zero");
        }
        //ensuring the reciever (to) is not a zero adddress
        if(to == address(0)) {
            revert InvalidAddress("reciever(to) can't be address zero");
        }
        //ensuring amount/value being transfered is not less than zero
        if(value < 0) {
            revert valueTooSmall("can't transfer less than 0 amount");
        }

        //assigning the balance of the account(from) to the varaible "fromBalance"
        uint256 fromBalance = _balance[from];

        //checking if the caller has enough balance to initiate the transfer
        if(fromBalance < value) {
            revert InsufficientBalance({
                available: _balance[from],
                required: value
            });
        }

        //transfer is initialized
        _balance[from] -= value;
        _balance[to] += value;

        //we emit an event when a transfer is carried out
        emit transferEvt(msg.sender, to, value);

        //it returns true when the transaction goes successfully 
        return true;
    }

    function approve(address _spender, uint256 _currentValue, uint256 _value) public returns (bool success) {
        //here we ensure that the spender address is a valid address and not address zero
        if(_spender == address(0)) {
            revert InvalidAddress("Spender can't be address 0");
        }
        //here we ensure that the current allowance is equal to the current amount/value
        if(_allowance[msg.sender][_spender] != _currentValue) {
            revert InvalidAllowance("Current allowance does not match provided currentAmount");
        }
  
        //here we assign the value allowed to be withdrawn by the spender
        _allowance[msg.sender][_spender] = _value;

        //here we emit an event to show the approval
        emit approveEvt(msg.sender, _spender, _currentValue, _value);

        //returns true if the transaction is successful
        return true;

    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {

        //ensuring the caller(from) is not address zero
        if(from == address(0)) {
            revert InvalidAddress("Sender(from) can't be zerro address");
        }
        //ensuring the reciever (to) is not a zero adddress
        if(to == address(0)) {
            revert InvalidAddress("reciever(to) can't be address zero");
        }
        //here we check if the account (from) has enough amount that can be transfered
        if(value > _balance[from]) {
            revert InsufficientBalance({
                available: _balance[from],
                required: value});
        }
        //here we check if the caller/msg.sender has enough allowance to transfer the amount the intend to
        if(value > _allowance[from][msg.sender]) {
            revert InvalidAllowance("amount greater than allowed amount");
        }    

        //here we update the caller/sender's allowance
        _allowance[from][msg.sender] -= value;

        //here we initiate the transfer 
        _balance[from] -= value;
        _balance[to] += value;
       
       //we emit an event when the transferFrom is successful
       emit transferFromEvt(msg.sender, from, to, value);

       //we return true when the transection goes successfully
        return true;

    }    

    // function approveAll(address _sender) public returns (bool){
    //     //here we ensure that the spender address is a valid address and not address zero
    //     if(_sender == address(0)) {
    //         revert InvalidAddress("Spender can't be address 0");
    //     }

    //     uint256 ownerBalance = _balance[msg.sender];

    //     if(ownerBalance < 0) {
    //         revert InsufficientBalance({
    //             available: ownerBalance,
    //             required: ownerBalance
    //         });
    //     }


    //     _spendAll[msg.sender][_sender] = ownerBalance;

    //     return true;
    // }


    //this function allows the sender to transfer all the callers balance
    function approveAll(address _sender, bool _canTransfer) public returns (bool){
        //this assigns message sender to the variable called owner
        address owner = msg.sender;

        //here we ensure that the spender address is a valid address and not address zero
        if(_sender == address(0)) {
            revert InvalidAddress("Sender can't be address 0");
        }

        //here we ensure that the spender address is a valid address and not address zero
        if(owner == address(0)) {
            revert InvalidAddress("caller can't be address 0");
        }        

        //this allows the sender to transfer all the balance from our account 
        _spendAll[owner][_sender] = _canTransfer;

        //here we emit an event to show the approval
        emit approveAllEvt(owner, _sender, _canTransfer);

        //this returns true if the transaction is successful
        return true;
    }   

}

