// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FamilyWallet is Ownable {
    uint256 public withdrawalLimit;
    mapping(address => bool) public approvedWallets;

    // Pass the initialOwner argument to the Ownable constructor
    constructor(address initialOwner) Ownable(initialOwner) {
        // Additional setup if required
    }

    // Set withdrawal limit
    function setWithdrawalLimit(uint256 _limit) external onlyOwner {
        withdrawalLimit = _limit;
    }

    // Approve or revoke a wallet's access
    function approveWallet(address wallet, bool status) external onlyOwner {
        approvedWallets[wallet] = status;
    }

    // Withdraw funds
    function withdraw(uint256 amount) external {
        require(approvedWallets[msg.sender], "Not an approved wallet");
        require(amount <= withdrawalLimit, "Exceeds withdrawal limit");
        require(address(this).balance >= amount, "Insufficient balance");

        // Transfer funds to the sender
        payable(msg.sender).transfer(amount);
    }

    // Fallback function to accept ETH
    receive() external payable {}
}
