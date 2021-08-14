// Copyright (C) 2021 Michal Drozd
// All Rights Reserved

pragma solidity ^0.4.24;

contract AdvancedToken {
    // Public variables to hold token name, symbol, decimals, and total supply
    string public name;
    string public symbol;
    uint8 public decimals;
    uint public totalSupply;

    // Mapping to hold the balance of each address
    mapping(address => uint) public balanceOf;

    // Event to be emitted on token transfer
    event Transfer(address indexed from, address indexed to, uint value);

    // Constructor function to initialize the contract
    constructor(string _name, string _symbol, uint8 _decimals, uint _totalSupply) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;
    }

    // Function to transfer tokens from one address to another
    function transfer(address _to, uint _value) public returns (bool) {
        // Check if the sender has enough balance
        require(balanceOf[msg.sender] >= _value);
        // Check if the recipient's balance will not overflow
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        // Subtract value from sender's balance
        balanceOf[msg.sender] -= _value;
        // Add value to recipient's balance
        balanceOf[_to] += _value;
        // Emit the Transfer event
        emit Transfer(msg.sender, _to, _value);
        // Return true on success
        return true;
    }
}