// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {TicTacToken} from "../src/TicTacToken.sol";
import {DeployTicTacToken} from "../script/DeployTicTacToken.s.sol";

/**
 * This helps to mock fn calls rather than using vm.prank again and again
 */
contract Player is Test {
    TicTacToken private ttt;
    address public playerAddress;

    constructor(TicTacToken _ttt, address _player) {
        ttt = _ttt;
        playerAddress = _player;
    }

    function markSpace(uint8 space) public {
        vm.prank(playerAddress);
        ttt.markSpace(space);
    }

}

contract TicTacTokenTest is Test {
    // Events
    event SpaceMarked(uint8 indexed space, TicTacToken.Symbol symbol);

    // State Variables
    TicTacToken ttt;
    Player X;
    Player O;
    address OWNER = msg.sender;

    function setUp() public {
        // Using Deployment Script
        DeployTicTacToken deployer = new DeployTicTacToken();
        (TicTacToken deployedTTT , address playerX, address playerO) = deployer.run();
        
        ttt = TicTacToken(deployedTTT);
        X = new Player(ttt, playerX);
        O = new Player(ttt, playerO);
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
        assert(ttt.getCurrentTurn() == X.playerAddress());
    }

    ///////////////////////////////
    // markSpace                 //
    ///////////////////////////////

    function test_cannot_mark_invalid_space() public {
        // Arrange
        uint8 invalidSpace = 9;
        // Act / Assert
        vm.expectRevert(TicTacToken.TicTacToken__InvalidSpace.selector);
        X.markSpace(invalidSpace);
    }

    function test_cannot_overwrite_marked_space() public {
        // Arrange
        X.markSpace(0);
        // Act / Assert
        vm.expectRevert(TicTacToken.TickTacToken__SpaceAlreadyMarked.selector);
        O.markSpace(0);
    }

    function test_can_mark_space_with_X() public {
        X.markSpace(0);
        assert(ttt.getBoardSpace(0) == TicTacToken.Symbol.X);
    }

    function test_can_mark_space_with_O() public {
        X.markSpace(0);
        O.markSpace(1);
        assert(ttt.getBoardSpace(1) == TicTacToken.Symbol.O);
    }

    function test_mark_space_updates_turn() public {
        X.markSpace(0);
        assert(ttt.getCurrentTurn() == O.playerAddress());
        O.markSpace(1);
        assert(ttt.getCurrentTurn() == X.playerAddress());
    }

    function test_mark_space_emits_event() public {
        // Arrange
        // Act / Assert
        vm.expectEmit(address(ttt)); // address of emit emitter
        uint8 markedSpace = 0;
        emit SpaceMarked(markedSpace, TicTacToken.Symbol.X); // expected emitted event
        X.markSpace(markedSpace);
    }

    ///////////////////////////////
    // getBoardSpace             //
    ///////////////////////////////
    function test_getBoardSpace_reverts_for_invalid_space() public {
        // Arrange // Act // Assert
        vm.expectRevert(TicTacToken.TicTacToken__InvalidSpace.selector);
        ttt.getBoardSpace(9);
    }
    // All other tcases are covered by markSpace tests

    ///////////////////////////////
    // getWinner                 //
    ///////////////////////////////

    function test_initally_no_winner() public view {
        assert(ttt.getWinner() == address(0));
    }

    function test_game_in_progress_returns_no_winner() public {
        X.markSpace(1);
        assert(ttt.getWinner() == address(0));
    }

    function test_draw_returns_no_winner() public {
        X.markSpace(4);
        O.markSpace(0);
        X.markSpace(1); 
        O.markSpace(7);
        X.markSpace(2);
        O.markSpace(6);
        X.markSpace(8);
        O.markSpace(5);
        assert(ttt.getWinner() == address(0));
    }

    function test_checks_for_horizontal_win() public {
        X.markSpace(0);
        O.markSpace(3);
        X.markSpace(1);
        O.markSpace(4);
        X.markSpace(2);
        assert(ttt.getWinner() == X.playerAddress());
    }

    function test_checks_for_horizontal_win_row2() public {
        X.markSpace(3);
        O.markSpace(0);
        X.markSpace(4);
        O.markSpace(1);
        X.markSpace(5);
        assert(ttt.getWinner() == X.playerAddress());
    }

    function test_checks_for_vertical_win() public {
        X.markSpace(1);
        O.markSpace(0);
        X.markSpace(2);
        O.markSpace(3);
        X.markSpace(4);
        O.markSpace(6);
        assert(ttt.getWinner() == O.playerAddress());
    }

    function test_checks_for_diagonal_win() public {
        X.markSpace(0);
        O.markSpace(1);
        X.markSpace(4);
        O.markSpace(5);
        X.markSpace(8);
        assert(ttt.getWinner() == X.playerAddress());
    }

    function test_checks_for_antidiagonal_win() public {
        X.markSpace(1);
        O.markSpace(2);
        X.markSpace(3);
        O.markSpace(4);
        X.markSpace(5);
        O.markSpace(6);
        assert(ttt.getWinner() == O.playerAddress());
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
