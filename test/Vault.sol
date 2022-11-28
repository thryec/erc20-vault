// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import {Vm} from "forge-std/Vm.sol";
import "../src/Vault.sol";
import "../src/HubToken.sol";

abstract contract StateZero is Test {
    HubToken internal token;
    Vault internal vault;

    address alice;
    address bob;

    function setUp() public virtual {
        token = new HubToken();
        address tokenAddr = address(token);
        vault = new Vault(tokenAddr);

        alice = address(0x1);
        bob = address(0x2);

        vm.label(alice, "alice");
        vm.label(bob, "bob");
    }
}

contract StateZeroTest is StateZero {
    function testERC20Address() public {
        address tokenAddr = address(token);
    }
}
