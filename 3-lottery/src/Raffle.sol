// Layout of Contract:- SOLIDITY DOCS
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

/// @title Sample Raffle Contract
/// @author Aman
/// @notice This contract implements a sample raffle
/// @dev Implements chainlink VRFv2
contract Raffle {
    /* Errors */
    error Raffle__NotEnoughETHSent();

    uint256 private i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughETHSent();
        }
    }

    function pickWinner() external {}

    /* Getters */

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }
}
