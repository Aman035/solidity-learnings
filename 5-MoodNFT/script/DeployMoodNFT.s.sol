// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNFT is Script {

    function run() external returns (MoodNFT) {
        string memory happySvg = vm.readFile("./images/happy.svg");
        string memory sadSvg = vm.readFile("./images/sad.svg");
        vm.startBroadcast();
        MoodNFT moodNFT = new MoodNFT(encodeSvgToBase64(happySvg), encodeSvgToBase64(sadSvg));
        vm.stopBroadcast();
        return moodNFT;
    }

    function encodeSvgToBase64(string memory svg) public pure returns (string memory) {
        return string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svg))));
    }
}
