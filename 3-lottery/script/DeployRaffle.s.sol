// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "./Interactions.s.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint256 entranceFee,
            uint256 interval,
            address vrfCoordinatorV2,
            bytes32 gasLane,
            uint64 subscriptionId,
            uint32 callbackGasLimit,
            address linkToken,
            uint256 deployerKey
        ) = helperConfig.s_activeNetworkConfig();

        /**
         * 1. Create Subscription if not already created
         */
        if (subscriptionId == 0) {
            CreateSubscription createSubscription = new CreateSubscription();
            subscriptionId = createSubscription.createSubscription(vrfCoordinatorV2, deployerKey);
            helperConfig.updateSubscriptionId(subscriptionId);

            /**
             * 2. Fund Subscription if not already funded
             * Since it is a 1 time deploy, assuming if a subscription is created, it is funded
             */
            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(vrfCoordinatorV2, subscriptionId, linkToken, deployerKey);
        }

        /**
         * 3. Deploy Raffle Contract
         */
        // Deployer Key is used to deploy the contract
        vm.startBroadcast(deployerKey);
        Raffle raffle = new Raffle(entranceFee, interval, vrfCoordinatorV2, gasLane, subscriptionId, callbackGasLimit);
        vm.stopBroadcast();

        /**
         * 4. Add Raffle as consumer if not alreday done
         */
        AddConsumer addConsumer = new AddConsumer();
        addConsumer.addConsumer(vrfCoordinatorV2, subscriptionId, address(raffle), deployerKey);

        return (raffle, helperConfig);
    }
}
