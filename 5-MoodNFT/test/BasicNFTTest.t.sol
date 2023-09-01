// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";

contract BasicNFTTest is Test {
    BasicNFT basicNFT;
    address USER = makeAddr("user");
    string constant URI = "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/3793";

    function setUp() public {
        DeployBasicNFT deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    ////////////////
    // Initial State
    ////////////////
    function testNFTName() public {
        assertEq(basicNFT.name(), "Dogie");
    }

    function testNFSymbol() public {
        assertEq(basicNFT.symbol(), "DOG");
    }

    ////////////////
    // Mint
    ////////////////
    function testNFTMint() public {
        vm.prank(USER);
        basicNFT.mint(URI);
        assertEq(basicNFT.balanceOf(USER), 1);
        assertEq(basicNFT.tokenURI(0), URI);
    }
}
