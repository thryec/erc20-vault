// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/yield-utils-v2/contracts/mocks/ERC20Mock.sol";

contract HubToken is ERC20Mock {
    constructor() ERC20Mock("HUB", "Hubble") {}
}
