// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {TicTacToken} from "../src/TicTacToken.sol";
import {DeployTicTacToken} from "../script/DeployTicTacToken.s.sol";

contract TicTacTokenTest is Test {
    // Events
    event SpaceMarked(uint8 indexed space, TicTacToken.Symbol symbol);

    // State Variables
    TicTacToken ttt;
    address playerX;
    address playerO;
    address OWNER = msg.sender;

    function setUp() public {
        // Using Deployment Script
        DeployTicTacToken deployer = new DeployTicTacToken();
        (ttt, playerX, playerO) = deployer.run();
    }

    ///////////////////////////////
    // Initial State Tests       //
    ///////////////////////////////
    function test_initially_empty_board() public view {
        TicTacToken.Symbol[9] memory board = ttt.getBoard();
        for (uint256 i = 0; i < 9; i++) {
            assert(board[i] == TicTacToken.Symbol.EMPTY);
        }
    }

    function test_initial_turn_is_of_playerX() public view {
        assert(ttt.currentTurn() == playerX);
    }

    ///////////////////////////////
    // markSpace                 //
    ///////////////////////////////

    function test_cannot_mark_invalid_space() public {
        // Arrange
        uint8 invalidSpace = 9;
        // Act / Assert
        vm.prank(playerX);
        vm.expectRevert(TicTacToken.TicTacToken__InvalidSpace.selector);
        ttt.markSpace(invalidSpace);
    }

    function test_cannot_overwrite_marked_space() public {
        // Arrange
        vm.prank(playerX);
        ttt.markSpace(0);
        // Act / Assert
        vm.prank(playerO);
        vm.expectRevert(TicTacToken.TickTacToken__SpaceAlreadyMarked.selector);
        ttt.markSpace(0);
    }

    function test_can_mark_space_with_X() public {
        vm.prank(playerX);
        ttt.markSpace(0);
        assert(ttt.getBoardSpace(0) == TicTacToken.Symbol.X);
    }

    function test_can_mark_space_with_O() public {
        vm.prank(playerX);
        ttt.markSpace(0);
        vm.prank(playerO);
        ttt.markSpace(1);
        assert(ttt.getBoardSpace(1) == TicTacToken.Symbol.O);
    }

    function test_mark_space_updates_turn() public {
        vm.prank(playerX);
        ttt.markSpace(0);
        assert(ttt.currentTurn() == playerO);
        vm.prank(playerO);
        ttt.markSpace(1);
        assert(ttt.currentTurn() == playerX);
    }

    function test_mark_space_emits_event() public {
        // Arrange
        // Act / Assert
        vm.expectEmit(address(ttt)); // address of emit emitter
        uint8 markedSpace = 0;
        vm.prank(playerX);
        emit SpaceMarked(markedSpace, TicTacToken.Symbol.X); // expected emitted event
        ttt.markSpace(markedSpace);
    }

    ///////////////////////////////
    // getBoardSpace             //
    ///////////////////////////////
    function test_getBoardSpace_reverts_for_invalid_space() public {
        // Arrange
        uint8 invalidSpace = 9;
        // Act / Assert
        vm.expectRevert(TicTacToken.TicTacToken__InvalidSpace.selector);
        ttt.getBoardSpace(invalidSpace);
    }
    // All other tcases are covered by markSpace tests

    ///////////////////////////////
    // getWinner                 //
    ///////////////////////////////

    function test_initally_no_winner() public view {
        assert(ttt.getWinner() == address(0));
    }

    function test_game_in_progress_returns_no_winner() public {
        vm.prank(playerX);
        ttt.markSpace(1);
        assert(ttt.getWinner() == address(0));
    }

    function test_draw_returns_no_winner() public {
        vm.prank(playerX);
        ttt.markSpace(4); // X
        vm.prank(playerO);
        ttt.markSpace(0); // O
        vm.prank(playerX);
        ttt.markSpace(1); // X
        vm.prank(playerO);
        ttt.markSpace(7); // O
        vm.prank(playerX);
        ttt.markSpace(2); // X
        vm.prank(playerO);
        ttt.markSpace(6); // O
        vm.prank(playerX);
        ttt.markSpace(8); // X
        vm.prank(playerO);
        ttt.markSpace(5); // O
        assert(ttt.getWinner() == address(0));
    }

    function test_checks_for_horizontal_win() public {
        vm.prank(playerX);
        ttt.markSpace(0); // X
        vm.prank(playerO);
        ttt.markSpace(3); // O
        vm.prank(playerX);
        ttt.markSpace(1); // X
        vm.prank(playerO);
        ttt.markSpace(4); // O
        vm.prank(playerX);
        ttt.markSpace(2); // X
        assert(ttt.getWinner() == playerX);
    }

    function test_checks_for_horizontal_win_row2() public {
        vm.prank(playerX);
        ttt.markSpace(3); // X
        vm.prank(playerO);
        ttt.markSpace(0); // O
        vm.prank(playerX);
        ttt.markSpace(4); // X
        vm.prank(playerO);
        ttt.markSpace(1); // O
        vm.prank(playerX);
        ttt.markSpace(5); // X
        assert(ttt.getWinner() == playerX);
    }

    function test_checks_for_vertical_win() public {
        vm.prank(playerX);
        ttt.markSpace(1); // X
        vm.prank(playerO);
        ttt.markSpace(0); // O
        vm.prank(playerX);
        ttt.markSpace(2); // X
        vm.prank(playerO);
        ttt.markSpace(3); // O
        vm.prank(playerX);
        ttt.markSpace(4); // X
        vm.prank(playerO);
        ttt.markSpace(6); // O
        assert(ttt.getWinner() == playerO);
    }

    function test_checks_for_diagonal_win() public {
        vm.prank(playerX);
        ttt.markSpace(0); // X
        vm.prank(playerO);
        ttt.markSpace(1); // O
        vm.prank(playerX);
        ttt.markSpace(4); // X
        vm.prank(playerO);
        ttt.markSpace(5); // O
        vm.prank(playerX);
        ttt.markSpace(8); // X
        assert(ttt.getWinner() == playerX);
    }

    function test_checks_for_antidiagonal_win() public {
        vm.prank(playerX);
        ttt.markSpace(1); // X
        vm.prank(playerO);
        ttt.markSpace(2); // O
        vm.prank(playerX);
        ttt.markSpace(3); // X
        vm.prank(playerO);
        ttt.markSpace(4); // O
        vm.prank(playerX);
        ttt.markSpace(5); // X
        vm.prank(playerO);
        ttt.markSpace(6); // O
        assert(ttt.getWinner() == playerO);
    }

    ///////////////////////////////
    // getOwner                  //
    ///////////////////////////////
    function test_getOwner() public view {
        assert(ttt.getOwner() == msg.sender);
    }

    ///////////////////////////////
    // resetBoard                //
    ///////////////////////////////
    function test_resetBoard_revert_for_non_owner() public {
        // Arrange
        address nonOwner = makeAddr("nonOwner");
        // Act / Assert
        vm.expectRevert(TicTacToken.TickTacToken__Unauthorized.selector);
        vm.prank(nonOwner);
        ttt.resetBoard();
    }

    function test_resetBoard_when_called_by_owner() public {
        vm.prank(OWNER);
        ttt.resetBoard();
    }

    function test_resetBoard_resets_board() public {
        vm.prank(OWNER);
        ttt.resetBoard();
        TicTacToken.Symbol[9] memory board = ttt.getBoard();
        for (uint256 i = 0; i < 9; i++) {
            assert(board[i] == TicTacToken.Symbol.EMPTY);
        }
    }
}
