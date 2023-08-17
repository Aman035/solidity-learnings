// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";

/**
 * @title Raffle Contract
 * @author Aman
 * @notice This contract implements a sample raffle
 * @dev Implements chainlink VRFv2 & chainlink automation
 */
contract Raffle is VRFConsumerBaseV2, AutomationCompatibleInterface {
    /* Errors */
    error Raffle__NotEnoughETHSent();
    error Raffle__TransactionFailed();
    error Raffle__NotOpen();
    error Raffle__UpkeepNotNeeded(uint256 balance, uint256 playersLength, uint256 raffleState);

    /* Interfaces */
    VRFCoordinatorV2Interface private i_vrfCoorditnator;

    /* Type Declarations */
    enum RaffleState {
        OPEN,
        CALCULATING_WINNER
    }

    /* State Variables */
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint16 private REQUEST_CONFIRMATIONS = 2;
    uint32 private i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;
    uint256 private i_entranceFee;
    /// @dev Lottery Interval in seconds
    uint256 private i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimeStamp;
    address payable private s_recentWinner;
    RaffleState private s_raffleState;

    /* Events */
    event EnteredRaffle(address indexed player);
    event PickedWinner(address indexed winner);

    /* Functions */
    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_vrfCoorditnator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughETHSent();
        }
        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__NotOpen();
        }
        s_players.push(payable(msg.sender));
        emit EnteredRaffle(msg.sender);
    }

    /**
     * @dev This function is called by the Chainlink Automation Node and check if conditions are meet to pick a winner
     * 1. Time Passed is greater than interval
     * 2. Raffle is OPEN
     * 3. Raffle has ETH
     * 4. Raffle has Players
     */
    function checkUpkeep(bytes memory /* checkData */ )
        public
        view
        override
        returns (bool upkeepNeeded, bytes memory /* performData */ )
    {
        bool timePassed = (block.timestamp - s_lastTimeStamp) >= i_interval;
        bool raffleIsOpen = s_raffleState == RaffleState.OPEN;
        bool raffleHasETH = address(this).balance > 0;
        bool raffleHasPlayers = s_players.length > 0;
        upkeepNeeded = timePassed && raffleIsOpen && raffleHasETH && raffleHasPlayers;
        return (upkeepNeeded, ""); // Returning empty bytes
    }

    /**
     * @dev This function is called by the Chainlink Automation Node and chooses the winner of Raffle
     */
    function performUpkeep(bytes calldata /* performData */ ) external override {
        (bool upkeepNeeded,) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert Raffle__UpkeepNotNeeded(address(this).balance, s_players.length, uint256(s_raffleState));
        }
        s_raffleState = RaffleState.CALCULATING_WINNER;
        i_vrfCoorditnator.requestRandomWords(
            i_gasLane, i_subscriptionId, REQUEST_CONFIRMATIONS, i_callbackGasLimit, NUM_WORDS
        );
    }

    /**
     * @notice Using CEI Design Pattern (Checks-Effects-Interactions)
     * 1. Checks - Using require() and conditional reverts, helps in gas optimized state reverts
     * 2. Effects - Affect our own contract state
     * 3. Interactions - Interact with other contracts
     */
    function fulfillRandomWords(uint256, /* requestId */ uint256[] memory randomWords) internal override {
        // Checks
        // Effects
        address payable winner = s_players[randomWords[0] % s_players.length];
        s_recentWinner = winner;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
        emit PickedWinner(winner);
        // Interactions
        (bool success,) = winner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransactionFailed();
        }
    }

    /* Getters */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    function getPlayer(uint256 indexOfPlayer) external view returns (address payable) {
        return s_players[indexOfPlayer];
    }

    function getPlayers() external view returns (address payable[] memory) {
        return s_players;
    }

    function getLastTimeStamp() external view returns (uint256) {
        return s_lastTimeStamp;
    }

    function getRecentWinner() external view returns (address payable) {
        return s_recentWinner;
    }

    function getRaffleState() external view returns (RaffleState) {
        return s_raffleState;
    }
}
