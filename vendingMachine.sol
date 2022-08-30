// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract vendingMachine {
    // STATE VARIABLES: owner, donutBalances
    address public owner;
    mapping (address => uint) public donutBalances;

    // set owner, set initial balance of vending machine
    constructor() {
        owner = msg.sender;
        donutBalances[address(this)] = 100;
    }

    // FUNCTIONS: getVendingMachineBalance(), restock(), purchase()

    // gets the current number of stocked donuts in the vending machine
    function getVendingMachineBalance() public view returns (uint) {
        return donutBalances[address(this)];
    }

    // requires only the owner to restock the vending machine, vending machine is restocked with "uint amount" donut(s) 
    function restock(uint amount) public {
        require(msg.sender == owner, "Only the owner of the vending machine can restock it.");
        donutBalances[address(this)] += amount;
    }

    // requires the buyer to have at least 1 ether to purchase a single donut, requires the vending machine to have enough donuts in stock to fufill the request, owner of the vending machine looses "uint amount" donut(s), buyer gains "uint amount" donut(s)
    function purchase(uint amount) public payable {
        require(msg.value >= amount * 1 ether, "You must pay at least 1 ether per donut");
        require(donutBalances[address(this)] >= amount, "Not enough donuts in stock to complete transaction");
        donutBalances[address(this)] -= amount;
        donutBalances[msg.sender] += amount;
    }
}