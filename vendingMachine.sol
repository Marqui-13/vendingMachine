// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract VendingMachine {
    // STATE VARIABLES
    address public owner;
    address public newOwner;
    uint public donutPrice;
    mapping(address => uint) public donutBalances;

    // EVENTS
    event Restocked(uint amount, uint addedFunds);
    event Purchased(address indexed buyer, uint amount, uint totalCost, uint refund);
    event DonutPriceUpdated(uint newPrice);
    event Withdrawn(address indexed owner, uint amount);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    // CONSTRUCTOR
    constructor(uint _initialStock, uint _donutPrice) {
        require(_donutPrice > 0, "Price must be greater than zero.");
        owner = msg.sender;
        donutBalances[address(this)] = _initialStock;
        donutPrice = _donutPrice;
    }

    // VIEW FUNCTION
    function getVendingMachineBalance() public view returns (uint) {
        return donutBalances[address(this)];
    }

    // RESTOCK FUNCTION (OWNER CAN ADD DONUTS & ETHER)
    function restock(uint amount) public payable {
        require(msg.sender == owner, "Only the owner can restock.");
        require(amount > 0, "Must restock at least 1 donut.");
        donutBalances[address(this)] += amount;
        emit Restocked(amount, msg.value);
    }

    // PURCHASE FUNCTION WITH EXCESS ETHER REFUND
    function purchase(uint amount) public payable {
        require(amount > 0, "Must purchase at least 1 donut.");
        uint totalCost = amount * donutPrice;
        require(msg.value >= totalCost, "Insufficient payment.");
        require(donutBalances[address(this)] >= amount, "Not enough donuts in stock.");

        // Transfer donuts
        donutBalances[address(this)] -= amount;
        donutBalances[msg.sender] += amount;

        // Refund excess Ether
        uint excess = msg.value - totalCost;
        if (excess > 0) {
            safeTransferETH(msg.sender, excess);
        }

        emit Purchased(msg.sender, amount, totalCost, excess);
    }

    // FUNCTION TO UPDATE DONUT PRICE
    function updateDonutPrice(uint newPrice) public {
        require(msg.sender == owner, "Only the owner can update the price.");
        require(newPrice > 0, "Price must be greater than zero.");
        donutPrice = newPrice;
        emit DonutPriceUpdated(newPrice);
    }

    // FUNCTION TO WITHDRAW ETHER (REENTRANCY SAFE)
    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw.");
        uint balance = address(this).balance;
        require(balance > 0, "No funds available.");
        
        safeTransferETH(owner, balance);
        emit Withdrawn(owner, balance);
    }

    // OWNERSHIP TRANSFER FUNCTION (TWO-STEP)
    function transferOwnership(address _newOwner) public {
        require(msg.sender == owner, "Only the owner can transfer ownership.");
        require(_newOwner != address(0), "Invalid new owner.");
        require(_newOwner != owner, "New owner must be different.");
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner, "Only the new owner can accept ownership.");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

    // INTERNAL FUNCTION FOR SAFE ETH TRANSFERS
    function safeTransferETH(address to, uint256 amount) internal {
        (bool success, ) = to.call{value: amount, gas: 2300}("");
        require(success, "ETH transfer failed");
    }

    // RECEIVE FUNCTION TO ACCEPT ETHER
    receive() external payable {}

    // FALLBACK FUNCTION TO PREVENT ACCIDENTAL TRANSFERS
    fallback() external payable {
        revert("Direct Ether transfers not allowed.");
    }