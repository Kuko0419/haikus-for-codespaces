// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FamilyWallet is Ownable {
    IERC20 public token; // This is the ERC20 token (e.g., USDC, USDT, etc.)
    mapping(address => bool) public approvedWallets; // List of approved wallets
    uint256 public withdrawalLimit; // Optional withdrawal limit

    event FundsWithdrawn(address indexed wallet, uint256 amount);
    event WalletApproved(address wallet, bool status);

    constructor(IERC20 _token) {
        token = _token;
        withdrawalLimit = 0; // No limit by default
    }

    // Approve or revoke access for wallets
    function approveWallet(address wallet, bool status) external onlyOwner {
        approvedWallets[wallet] = status;
        emit WalletApproved(wallet, status);
    }

    // Withdraw funds to an approved wallet
    function withdraw(uint256 amount) external {
        require(approvedWallets[msg.sender], "Not an approved wallet");
        require(amount <= withdrawalLimit || withdrawalLimit == 0, "Exceeds withdrawal limit");

        token.transfer(msg.sender, amount);
        emit FundsWithdrawn(msg.sender, amount);
    }

    // Set withdrawal limit
    function setWithdrawalLimit(uint256 _limit) external onlyOwner {
        withdrawalLimit = _limit;
    }

    // Transfer ownership to a new address
    function transferOwnership(address newOwner) public override onlyOwner {
        super.transferOwnership(newOwner);
    }
}