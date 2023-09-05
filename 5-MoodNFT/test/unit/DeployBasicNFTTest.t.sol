// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";
import {DeployBasicNFT} from "../../script/DeployBasicNFT.s.sol";

contract DeployBasicNFTTest is Test {
    DeployBasicNFT deployBasicNFT;

    function setUp() public {
        deployBasicNFT = new DeployBasicNFT();
    }

    function testDeployMoodNFTDeploysNewMoodNFTInstance() public {
        deployBasicNFT.run();
    }
}
