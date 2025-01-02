// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract WalletControl {
    address private owner;

    // Ether and token balances
    mapping(address => uint256[]) private etherBalances;
    mapping(address => mapping(address => uint256)) private tokenBalances;

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized: Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Get the owner of the contract
    function getOwner() external view returns (address) {
        return owner;
    }

    // Deposit Ether into the contract
    function depositEther() external payable {
        require(msg.value > 0, "Must send some Ether");
        etherBalances[msg.sender].push(msg.value);
    }

    // Deposit ERC20 tokens into the contract
    function depositToken(address token, uint256 amount) external {
        require(amount > 0, "Must deposit tokens");
        IERC20(token).transfer(address(this), amount); // Requires approval first
        tokenBalances[msg.sender][token] += amount;
    }

    // Get Ether balances for an account
    function getEtherBalance(address account) external view returns (uint256[] memory) {
        return etherBalances[account];
    }

    // Get ERC20 token balance for an account
    function getTokenBalance(address account, address token) external view returns (uint256) {
        return tokenBalances[account][token];
    }

    // Withdraw Ether from the contract (only owner)
    function withdrawEther(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient Ether balance");
        payable(msg.sender).transfer(amount);
    }

    // Withdraw ERC20 tokens from the contract (only owner)
    function withdrawToken(address token, uint256 amount) external onlyOwner {
        require(tokenBalances[msg.sender][token] >= amount, "Insufficient token balance");
        tokenBalances[msg.sender][token] -= amount;
        IERC20(token).transfer(msg.sender, amount);
    }
}