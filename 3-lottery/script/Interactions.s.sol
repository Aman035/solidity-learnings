//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "../test/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkTokenMock.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {Raffle} from "../src/Raffle.sol";

/**
 * @title CreateSubscription Script for VRFCoordinatorV2Mock
 * Although Deployer uses the createSubscription, run & createSubscriptionFromConfig are kept for testing purposes and making the script standalone
 */
contract CreateSubscription is Script {
    function run() external returns (uint64) {
        return createSubscriptionFromConfig();
    }

    function createSubscriptionFromConfig() public returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        (,, address vrfCoordinatorV2,,,,, uint256 deployerKey) = helperConfig.s_activeNetworkConfig();
        return createSubscription(vrfCoordinatorV2, deployerKey);
    }

    function createSubscription(address vrfCoordinatorV2, uint256 deployerKey) public returns (uint64 subscriptionId) {
        VRFCoordinatorV2Mock vrfCoordinator = VRFCoordinatorV2Mock(vrfCoordinatorV2);
        vm.startBroadcast(deployerKey);
        subscriptionId = vrfCoordinator.createSubscription();
        vm.stopBroadcast();
        console.log("SUBSCRIPTION CREATED WITH ID: %s", subscriptionId);
    }
}

/**
 * @title FunSubscription Script for VRFCoordinatorV2Mock
 * Although Deployer uses the fundSubscription, run & fundSubscriptionFromConfig are kept for testing purposes and making the script standalone
 */
contract FundSubscription is Script {
    uint96 LINK_TOKEN_FUNDED = 20 ether;

    function run() external {
        fundSubscriptionFromConfig();
    }

    function fundSubscriptionFromConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        (,, address vrfCoordinatorV2,, uint64 subscriptionId,, address linkToken, uint256 deployerKey) =
            helperConfig.s_activeNetworkConfig();
        fundSubscription(vrfCoordinatorV2, subscriptionId, linkToken, deployerKey);
    }

    function fundSubscription(address vrfCoordinatorV2, uint64 subscriptionId, address linkToken, uint256 deployerKey)
        public
    {
        console.log("Funding subscription: ", subscriptionId);
        console.log("Using vrfCoordinator: ", vrfCoordinatorV2);
        console.log("On ChainID: ", block.chainid);

        uint256 anvilChainId = 31337;
        VRFCoordinatorV2Mock vrfCoordinator = VRFCoordinatorV2Mock(vrfCoordinatorV2);
        // Custom Logic for Anvil chain
        // Reason - Fund Subscription Works differntly for MOCK Contract
        if (block.chainid == anvilChainId) {
            vm.startBroadcast(deployerKey);
            vrfCoordinator.fundSubscription(subscriptionId, LINK_TOKEN_FUNDED);
            vm.stopBroadcast();
        } else {
            // Note - deployer should have enough LINK to fund the subscription
            vm.startBroadcast(deployerKey);
            // On any network we have to call trnasferAndCall fn of LinkToken to fund
            LinkToken(linkToken).transferAndCall(vrfCoordinatorV2, LINK_TOKEN_FUNDED, abi.encode(subscriptionId));
            vm.stopBroadcast();
        }
        console.log("SUBSCRIPTION FUNDED WITH ID: %s", subscriptionId);
    }
}

/**
 * @title AddConsumer Script for VRFCoordinatorV2Mock
 * Although Deployer uses the addConsumer, run & addConsumerUsingConfig are kept for testing purposes and making the script standalone
 */
contract AddConsumer is Script {
    function run() external {
        // Get the consumer address as the latest Deployed Raffle Contract
        address raffleAddress = DevOpsTools.get_most_recent_deployment("Raffle", block.chainid);
        addConsumerUsingConfig(raffleAddress);
    }

    function addConsumerUsingConfig(address consumer) public {
        HelperConfig helperConfig = new HelperConfig();
        (,, address vrfCoordinatorV2,, uint64 subscriptionId,,, uint256 deployerKey) =
            helperConfig.s_activeNetworkConfig();
        addConsumer(vrfCoordinatorV2, subscriptionId, consumer, deployerKey);
    }

    function addConsumer(address vrfCoordinatorV2, uint64 subscriptionId, address consumer, uint256 deployerKey)
        public
    {
        console.log("Adding Consumer: ", consumer);
        console.log("To subscription: ", subscriptionId);
        console.log("Using vrfCoordinator: ", vrfCoordinatorV2);
        console.log("On ChainID: ", block.chainid);
        VRFCoordinatorV2Mock vrfCoordinator = VRFCoordinatorV2Mock(vrfCoordinatorV2);
        vm.startBroadcast(deployerKey);
        // on checking the fn definition, it just returns if consumer is already added
        vrfCoordinator.addConsumer(subscriptionId, consumer);
        vm.stopBroadcast();
        console.log("CONSUMER ADDED");
    }
}
