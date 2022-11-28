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

    event Deposit(address indexed user, uint256 numTokens);
    event Withdraw(address indexed user, uint256 numTokens);

    error NoDeposits();
    error InsufficientAmount(uint256 available, uint256 requested);

    function setUp() public virtual {
        token = new HubToken();
        vault = new Vault(address(token));

        alice = address(0x1);
        vm.label(alice, "alice");
        token.mint(alice, 1000000);
    }
}

contract StateZeroTest is StateZero {
    function testDepositFailsWithoutApproval() public {
        vm.expectRevert(bytes("ERC20: Insufficient approval"));
        vm.prank(alice);
        vault.deposit(100);
    }

    function testDeposit() public {
        vm.startPrank(alice);
        token.approve(address(vault), 100);
        vault.deposit(100);
        vm.stopPrank();
        uint256 amountDeposited = vault.records(alice);
        assertEq(amountDeposited, 100);
    }

    function testDepositEmitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Deposit(alice, 100);
        vm.startPrank(alice);
        token.approve(address(vault), 100);
        vault.deposit(100);
        vm.stopPrank();
    }

    function testWithdrawFails() public {
        vm.expectRevert(NoDeposits.selector);
        vault.withdraw(100);
    }
}

abstract contract StateOne is StateZero {
    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(alice);
        token.approve(address(vault), 100);
        vault.deposit(100);
        vm.stopPrank();
    }
}

contract StateOneTest is StateOne {
    function testWithdrawPartial() public {
        vm.startPrank(alice);
        vault.withdraw(50);
        uint256 amountRemaining = vault.records(alice);
        assertEq(amountRemaining, 50);
        vm.stopPrank();
    }

    function testWithdrawFull() public {
        vm.startPrank(alice);
        vault.withdraw(100);
        uint256 amountRemaining = vault.records(alice);
        assertEq(amountRemaining, 0);
        vm.stopPrank();
    }

    function testWithdrawEmitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit Withdraw(alice, 100);
        vm.startPrank(alice);
        vault.withdraw(100);
        vm.stopPrank();
    }

    function testWithdrawFailsIfInsufficient() public {
        vm.expectRevert(
            abi.encodeWithSelector(InsufficientAmount.selector, 100, 101)
        );
        vm.startPrank(alice);
        vault.withdraw(101);
        vm.stopPrank();
    }
}
