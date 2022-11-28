// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console2.sol";
import "lib/yield-utils-v2/contracts/token/IERC20.sol";

contract Vault {
    uint256 public number;
    IERC20 public immutable token;
    mapping(address => uint256) public records;

    event Deposit(address indexed user, uint256 numTokens);
    event Withdraw(address indexed user, uint256 numTokens);

    error NoDeposits();
    error InsufficientAmount(uint256 available, uint256 requested);
    error TransferFailed();

    constructor(address erc20Address) {
        token = IERC20(erc20Address);
    }

    function deposit(uint256 amount) public {
        records[msg.sender] = amount;
        bool success = token.transferFrom(msg.sender, address(this), amount);
        if (!success) {
            revert TransferFailed();
        }
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        if (records[msg.sender] == 0) {
            revert NoDeposits();
        }
        if (records[msg.sender] < amount) {
            revert InsufficientAmount(records[msg.sender], amount);
        }
        records[msg.sender] -= amount;
        bool success = token.transferFrom(address(this), msg.sender, amount);
        if (!success) {
            revert TransferFailed();
        }

        emit Withdraw(msg.sender, amount);
    }
}
