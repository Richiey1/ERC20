// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

error InvalidAddress();
error InsufficientAmount();
error InsufficientAllowance();
error OnlyOwnerAllowed();
error InvalidAmount();
error InsufficientFunds();
error InvalidFunds();

contract ERC20 {
    string _name;
    string _symbol;
    uint8 _decimals;
    uint256 _totalSupply;
    address owner;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Minted(address indexed _to, uint256 _value);
    

    modifier onlyOwner() {
        if(msg.sender != owner) revert OnlyOwnerAllowed();
        _;
    }
    constructor(string memory name_, string memory symbol_, uint8 decimals_, uint256 totalSupply_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
        _totalSupply = totalSupply_;
        owner = msg.sender;
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
    function balanceOf(address _owner) public view returns(uint256 balance) {
        if(_owner == address(0)) revert InvalidAddress();
        balance = balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if(_to == address(0)) revert InvalidAddress();
        if(_value <= 0) revert InvalidAmount();
        if(_value > balances[msg.sender]) revert InsufficientFunds();
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        success = true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if(msg.sender == address(0) || _to == address(0) || _from == address(0)) revert InvalidAddress();
        if(_value <= 0) revert InvalidAmount();
        if(_value > balances[_from]) revert InsufficientFunds();
        if(_value > allowances[_from][msg.sender]) revert InsufficientAllowance();

        balances[_from] -= _value;
        allowances[_from][msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(_from, _to, _value);
        success = true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        if(_spender == address(0)) revert InvalidAddress();
        allowances[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        success = true;
    }
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        remaining = allowances[_owner][_spender]; 
        
    }
    function mint(address _to, uint256 _value) public onlyOwner returns (bool success) {
        if(_to == address(0)) revert InvalidAddress();
        if(_value <= 0) revert InvalidAmount();

        _totalSupply += _value;
        balances[_to] += _value;
        
        emit Minted(_to, _value);
        success = true;
    }
    function burn( uint256 _value) public onlyOwner returns (bool success) {
        if(_value <= 0) revert InvalidAmount();
        if(balances[msg.sender] < _value) revert InsufficientFunds();

        balances[msg.sender] -= _value;
        _totalSupply -= _value;
        balances[address(0)] += _value;
        
        emit Transfer(msg.sender, address(0), _value);
        success = true;
    }
}
