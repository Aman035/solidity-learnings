// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Raffle} from "../../src/Raffle.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract RaffleTest is Test {
    /**
     * EVENTS
     * Events are taken from the Raffle contract and pasted here for testing purposes
     * Events can't be exported from the contract just like enums and hence we have to define them here
     */
    event EnteredRaffle(address indexed player);
    event PickedWinner(address indexed winner);

    Raffle raffle;
    HelperConfig helperConfig;
    address PLAYER = makeAddr("player"); // cheatcode - creates address from the given label
    uint256 constant STARTING_BALANCE = 100 ether;

    uint256 entranceFee;
    uint256 interval;
    address vrfCoordinatorV2;
    bytes32 gasLane;
    uint64 subscriptionId;
    uint32 callbackGasLimit;
    address linkToken;

    // Special FN - Runs before each test
    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();
        vm.deal(PLAYER, STARTING_BALANCE); // cheatcode - Sets balance of account to the given amount

        (entranceFee, interval, vrfCoordinatorV2, gasLane, subscriptionId, callbackGasLimit, linkToken,) =
            helperConfig.s_activeNetworkConfig();
    }

    /**
     * INITIAL STATE
     */
    function test_RaffleEntranceFee() public view {
        assert(raffle.getEntranceFee() == entranceFee);
    }

    function test_RaffleInitialPlayers() public view {
        assert(raffle.getPlayers().length == 0);
    }

    function test_RaffleInitialWinner() public view {
        assert(raffle.getRecentWinner() == address(0));
    }

    function test_RaffleInitialState() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }

    ////////////////////
    // enterRaffle()  //
    ////////////////////
    function test_RaffleRevertOnNotEnoughEntranceFee() public {
        // Arrange
        vm.prank(PLAYER);
        // Act / Assert
        vm.expectRevert(Raffle.Raffle__NotEnoughETHSent.selector);
        raffle.enterRaffle();
    }

    function test_RaffleRevertOnEnteringWhileCalcululatingWinner() public {
        // Arrange
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval); // cheatCode - Sets the time of blockchain to the given timestamp
        raffle.performUpkeep("");
        // Act / Assert
        vm.expectRevert(Raffle.Raffle__NotOpen.selector);
        raffle.enterRaffle{value: entranceFee}();

    }

    function test_RaffleRecordsPlayerOnEntrance() public {
        // Arrange
        vm.prank(PLAYER);
        // Act
        raffle.enterRaffle{value: entranceFee}();
        // Assert
        assert(raffle.getPlayers().length == 1);
        assert(raffle.getPlayers()[0] == PLAYER);
    }

    function test_EventEmittedOnEntrance() public {
        // Arrange
        vm.prank(PLAYER);
        /**
         * EVENT THAT WE EXPECT TO BE EMITTED
         * 1st 3 params depicts indexed and hence are part of the topic
         * 4th param is not indexed and hence is part of the data
         * 5th param is used to depict the address of contract which emitted the event
         */
        // Act / Assert
        vm.expectEmit(true, false, false, false, address(raffle));
        /**
         * Emit the event itself
         */
        emit EnteredRaffle(PLAYER);
        /**
         * Call the fn which events out the event
         */
        raffle.enterRaffle{value: entranceFee}();
    }

    ////////////////////
    // checkUpkeep()  //
    ////////////////////
}