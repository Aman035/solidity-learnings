// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FundMe} from "../../src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
/*
    In Foundry tests are written in solidity itself rather than using any Js / Ts Test Framework
    - For printing logs using verbosity Level 2
    - Fn with test prefix will be run as test
*/

contract FundMeTest is Test {
    FundMe fundMe;
    // cheatcode - creates address from the given label
    // https://book.getfoundry.sh/reference/forge-std/make-addr?highlight=MAKEADDR#makeaddr
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; // 1e17
    uint256 constant STARTING_BALANCE = 100 ether;

    // Special FN - Runs before each test
    function setUp() external {
        // Deploying using Deployment Script
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        // cheatcode - Sets balance of account to the given amount
        // https://book.getfoundry.sh/cheatcodes/deal?highlight=deal#deal
        vm.deal(USER, STARTING_BALANCE);
    }

    function test_MINIMUM_USD() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function test_OwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function test_FundFailsWithoutEnoughETH() public {
        // cheatcode - The next line after cm.expectRevert will be reverted
        // https://book.getfoundry.sh/cheatcodes/expect-revert
        vm.expectRevert();
        fundMe.fund();
    }

    function test_FundUpdatesFundedDataStructure() public {
        // cheatcode - Code btw vm.startPrank and vm.stopPrank will be executed by USER
        vm.startPrank(USER);
        fundMe.fund{value: SEND_VALUE}();
        vm.stopPrank();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function test_AddsFunderToArrayOfFunders() public {
        vm.startPrank(USER);
        fundMe.fund{value: SEND_VALUE}();
        vm.stopPrank();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    // https://twitter.com/PaulRBerg/status/1624763320539525121

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        assert(address(fundMe).balance > 0);
        _;
    }

    function test_OnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function test_WithdrawFromASingleFunder() public funded {
        // Arrange
        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        // vm.txGasPrice(GAS_PRICE);
        // uint256 gasStart = gasleft();
        // // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;

        // Assert
        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance // + gasUsed
        );
    }

    function test_WithDrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
            // we get hoax from stdcheats - prank + deal
            // address(i) - creates address from uint160
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
        assert((numberOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
    }

    function test_CheapWithDrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 2;
        for (uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++) {
            // we get hoax from stdcheats - prank + deal
            // address(i) - creates address from uint160
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingFundMeBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance);
        assert((numberOfFunders + 1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance);
    }
}
