// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFCoordinatorV2Mock} from "../test/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkTokenMock.sol";
import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    /* Interfaces */
    VRFCoordinatorV2Mock private s_vrfCoordinatorV2;

    /* State Variables */
    NetworkConfig public s_activeNetworkConfig;

    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint64 subscriptionId;
        uint32 callbackGasLimit;
        address linkToken;
        uint256 deployerKey;
    }

    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    /* Events */
    event HelperConfig__CreatedVRFCoordinatorV2Mock(address vrfCoordinatorV2);

    /* Functions */
    constructor() {
        if (block.chainid == 11155111) {
            s_activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            s_activeNetworkConfig = getMainnetEthConfig();
        } else {
            s_activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    /**
     * Iniitally subscriptionId is 0 and is updated by the DeployRaffle script
     * @param subscriptionId - updated subscriptionId
     */
    function updateSubscriptionId(uint64 subscriptionId) public {
        s_activeNetworkConfig.subscriptionId = subscriptionId;
    }

    function getSepoliaEthConfig() public view returns (NetworkConfig memory sepoliaNetworkConfig) {
        // Taken From - https://docs.chain.link/vrf/v2/subscription/supported-networks
        sepoliaNetworkConfig = NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            subscriptionId: 4542, // Already Created using Chainlink Dashboard
            callbackGasLimit: 100000,
            linkToken: 0x779877A7B0D9E8603169DdbD7836e478b4624789,
            deployerKey: vm.envUint("PRIVATE_KEY") // cheatcode - Reads private key from the env
        });
    }

    function getMainnetEthConfig() public view returns (NetworkConfig memory mainnetNetworkConfig) {
        // Taken From - https://docs.chain.link/vrf/v2/subscription/supported-networks
        mainnetNetworkConfig = NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: 0x271682DEB8C4E0901D1a1550aD2e64D568E69909,
            gasLane: 0x8af398995b04c28e9951adb9721ef74c74f93e6a478f39e7e0777be13527e7ef,
            subscriptionId: 0, // A simple placeholder
            callbackGasLimit: 100000,
            linkToken: 0x514910771AF9Ca656af840dff83E8264EcF986CA,
            deployerKey: vm.envUint("PRIVATE_KEY") // cheatcode - Reades private key from the env
        });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory anvilNetworkConfig) {
        // don't deploy mocking contracts if already deployed once
        if (s_activeNetworkConfig.vrfCoordinator != address(0)) {
            return s_activeNetworkConfig;
        }

        vm.startBroadcast();
        // Deploy Mock VRFCoordinatorV2 on Anvil
        uint96 baseFee = 0.25 ether; // 0.25 LINK // Base amount of Link Paid
        uint96 gasPriceLink = 1e9; // 1 GWEI // Amount of Link Spent for 1 unit of Gas
        s_vrfCoordinatorV2 = new VRFCoordinatorV2Mock(
            baseFee,
            gasPriceLink
        );

        // Deploy Mock LINK Token on Anvil
        LinkToken linkToken = new LinkToken();
        vm.stopBroadcast();

        emit HelperConfig__CreatedVRFCoordinatorV2Mock(address(s_vrfCoordinatorV2));

        anvilNetworkConfig = NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: address(s_vrfCoordinatorV2),
            gasLane: 0x8af398995b04c28e9951adb9721ef74c74f93e6a478f39e7e0777be13527e7ef, // This does not matter
            subscriptionId: 0,
            callbackGasLimit: 100000,
            linkToken: address(linkToken),
            deployerKey: DEFAULT_ANVIL_PRIVATE_KEY
        });
    }
}
