// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract MintBaiscNFT is Script {
    string public constant URI = "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/3793";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNFT", block.chainid);
        minNFTOnContract(mostRecentlyDeployed);
    }

    function minNFTOnContract(address basicNFTAddress) public {
        BasicNFT basicNFT = BasicNFT(basicNFTAddress);
        vm.startBroadcast();
        basicNFT.mint(URI);
        vm.stopBroadcast();
    }
}
