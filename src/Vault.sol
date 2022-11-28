// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/yield-utils-v2/contracts/token/IERC20.sol";

contract Vault {
    uint256 public number;
    IERC20 public token;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    constructor(address erc20Address) {
        token = IERC20(erc20Address);
    }
}
