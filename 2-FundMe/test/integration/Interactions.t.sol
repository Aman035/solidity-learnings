// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {FundMe} from "../../src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interactions.s.sol";
/*
    In Foundry tests are written in solidity itself rather than using any Js / Ts Test Framework
    - For printing logs using verbosity Level 2
    - Fn with test prefix will be run as test
*/

contract FundMeInteractionTest is Test {
    FundMe fundMe;

    // Special FN - Runs before each test
    function setUp() external {
        // Using Script to deploy
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testUserCanFundAndOwnerWithdraw() public {
        // Using Script to fund
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));
        // Using Script to withraw
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
