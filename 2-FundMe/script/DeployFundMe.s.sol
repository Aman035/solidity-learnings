// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

/*
    In solidity scripts are also in solidity itself
*/

contract DeployFundMe is Script {
    // Special Fn to deploy contracts
    function run() external returns (FundMe) {
        // Don't add this code in vm block because we don't want to spend any fee to deploy this contract ( This is just a helper contract )
        HelperConfig helperConfig = new HelperConfig();
        address priceFeed = helperConfig.activeNetworkConfig();

        // Everything btw vm.startBroadcast and vm.stopBroadcast will be send to rpc
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
