// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol"; // Import OpenZeppelin's Ownable

contract FamilyWallet is Ownable {
    // State variables
    uint256 public withdrawalLimit; // Maximum withdrawal amount
    mapping(address => bool) public approvedWallets; // Approved wallets mapping

    // Constructor to set the initial owner
    constructor(address initialOwner) Ownable() {
        transferOwnership(initialOwner); // Set the initial owner
    }

    // Set the withdrawal limit (onlyOwner can call this)
    function setWithdrawalLimit(uint256 _limit) external onlyOwner {
        withdrawalLimit = _limit;
    }

    // Approve or revoke a wallet's status
    function approveWallet(address wallet, bool status) external onlyOwner {
        approvedWallets[wallet] = status;
    }

    // Withdraw funds to an approved wallet
    function withdraw(uint256 amount) external {
        require(approvedWallets[msg.sender], "Not an approved wallet");
        require(amount <= withdrawalLimit, "Exceeds withdrawal limit");
        require(address(this).balance >= amount, "Insufficient contract balance");

        // Transfer the requested amount to the sender
        payable(msg.sender).transfer(amount);
    }

    // Fallback function to receive ETH
    receive() external payable {}

    // Function to get the contract's ETH balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}