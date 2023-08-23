// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {TicTacToken} from "../src/TicTacToken.sol";

contract TicTacTokenTest is Test {
    // Events
    event SpaceMarked(uint8 indexed space, TicTacToken.Symbol symbol);

    TicTacToken ttt;

    function setUp() public {
        ttt = new TicTacToken();
    }

    /////////////////////////////// 
    // Initial State Tests       //
    ///////////////////////////////
    function test_tttBoardIsEmpty() public view {
        TicTacToken.Symbol[9] memory board = ttt.getBoard();
        for (uint256 i = 0; i < 9; i++) {
            assert(board[i] == TicTacToken.Symbol.EMPTY);
        }
    }

    function test_ttt_initial_turn_is_of_player_X() public view {
        assert(ttt.currentTurn() == TicTacToken.Turn.X_TURN);
    }

    /////////////////////////////// 
    // markSpace                 //
    ///////////////////////////////

    function test_cannot_mark_invalid_space() public {
        // Arrange
        uint8 invalidSpace = 9;
        // Act / Assert
        vm.expectRevert(TicTacToken.TicTacToken__InvalidSpace.selector);
        ttt.markSpace(invalidSpace);
    }

    function test_cannot_overwrite_marked_space() public {
        // Arrange
        ttt.markSpace(0);
        // Act / Assert
        vm.expectRevert(TicTacToken.TickTacToken__SpaceAlreadyMarked.selector);
        ttt.markSpace(0);
    }

    function test_can_mark_space_with_X() public {
        ttt.markSpace(0);
        assert(ttt.getBoardSpace(0) == TicTacToken.Symbol.X);
    }

    function test_can_mark_space_with_O() public {
        ttt.markSpace(0);
        ttt.markSpace(1);
       assert(ttt.getBoardSpace(1) == TicTacToken.Symbol.O);
    }

    function test_mark_space_updates_turn() public {
        ttt.markSpace(0);
        assert(ttt.currentTurn() == TicTacToken.Turn.O_TURN);
        ttt.markSpace(1);
        assert(ttt.currentTurn() == TicTacToken.Turn.X_TURN);
    }

    function test_mark_space_emits_event() public {
        // Arrange
        // Act / Assert
        vm.expectEmit(address(ttt)); // address of emit emitter
        uint8 markedSpace = 0;
        emit SpaceMarked(markedSpace, TicTacToken.Symbol.X); // expected emitted event
        ttt.markSpace(markedSpace);
    }
}
