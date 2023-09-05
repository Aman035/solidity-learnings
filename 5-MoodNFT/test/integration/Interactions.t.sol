// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MintBaiscNFT, MintMoodNFT} from "../../script/Interactions.s.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";
import {MoodNFT} from "../../src/MoodNFT.sol";
import {DeployBasicNFT} from "../../script/DeployBasicNFT.s.sol";
import {DeployMoodNFT} from "../../script/DeployMoodNFT.s.sol";

contract MintBasicNFTTest is Test {
    MintBaiscNFT mintBasicNFT;
    BasicNFT basicNFT;
    address USER = makeAddr("user");

    function setUp() public {
        DeployBasicNFT deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
        mintBasicNFT = new MintBaiscNFT();
    }

    function testMintBasicNFT() public {
        mintBasicNFT.minNFTOnContract(address(basicNFT));
        assertEq(basicNFT.balanceOf(msg.sender), 1);
        assertEq(basicNFT.tokenURI(0), mintBasicNFT.URI());
    }
}

contract MintMoodNFTTest is Test {
    MintMoodNFT mintMoodNFT;
    MoodNFT moodNFT;
    address USER = makeAddr("user");

    function setUp() public {
        DeployMoodNFT deployer = new DeployMoodNFT();
        moodNFT = deployer.run();
        mintMoodNFT = new MintMoodNFT();
    }

    function testMintMoodNFT() public {
        mintMoodNFT.minNFTOnContract(address(moodNFT));
        assertEq(moodNFT.balanceOf(msg.sender), 1);
    }
}
