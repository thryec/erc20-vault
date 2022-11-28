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

    constructor(address erc20Address) {
        token = IERC20(erc20Address);
    }

    function deposit(uint256 amount) public {
        token.transferFrom(msg.sender, address(this), amount);
        records[msg.sender] = amount;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) public returns (uint256 updatedBalance) {
        if (records[msg.sender] == 0) {
            revert NoDeposits();
        }
        if (records[msg.sender] < amount) {
            revert InsufficientAmount(records[msg.sender], amount);
        }
        token.transferFrom(address(this), msg.sender, amount);
        uint256 newBalance = records[msg.sender] - amount;
        records[msg.sender] = newBalance;
        emit Withdraw(msg.sender, amount);
        return newBalance;
    }
}
