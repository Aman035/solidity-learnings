// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

/// @title Sample Raffle Contract
/// @author Aman
/// @notice This contract implements a sample raffle
/// @dev Implements chainlink VRFv2
contract Raffle is VRFConsumerBaseV2 {
    /* Errors */
    error Raffle__NotEnoughETHSent();
    error Raffle__TransactionFailed();
    error Raffle__NotOpen();

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

    function pickWinner() external {
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert();
        }
        s_raffleState = RaffleState.CALCULATING_WINNER;
        uint256 requestId = i_vrfCoorditnator.requestRandomWords(
            i_gasLane, i_subscriptionId, REQUEST_CONFIRMATIONS, i_callbackGasLimit, NUM_WORDS
        );
    }

    // CEI - Checks-Effects-Interactions
    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        // Checks ( using require() ) ( None Here )
        // Effects - Affect our own contract state
        address payable winner = s_players[randomWords[0] % s_players.length];
        s_recentWinner = winner;
        s_players = new address payable[](0);
        s_lastTimeStamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
        emit PickedWinner(winner);
        // Interactions - Interact with other contracts
        (bool success,) = winner.call{value: address(this).balance}("");
        if (!success) {
            revert Raffle__TransactionFailed();
        }
    }

    /* Getters */

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}
