// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title TicTacToken
 * @author Aman
 */
contract TicTacToken {
    /**
     * Errors
     */
    error TicTacToken__InvalidSpace();
    error TickTacToken__SpaceAlreadyMarked();
    error TickTacToken__NotYourTurn();

    /**
     * Interfaces
     */

    /**
     * Type Declarations
     */
    enum Symbol { EMPTY, X, O }
    enum Turn { X_TURN, O_TURN }

    /**
     * State Variables
     */
    Symbol[9] private s_board;
    Turn  private s_currentTurn;

    /**
     * Events
     */
    event SpaceMarked(uint8 indexed space, Symbol symbol);

    /**
     * Modifiers
     */
    // using uint8 to save gas
    modifier validSpace(uint8 space) {
        if (space > 8) {
            revert TicTacToken__InvalidSpace();
        }
        _;
    }

    /**
     * Functions
     */

    /**
     * External
     */
    function markSpace(uint8 space) external validSpace(space) {
        if (!_emptySpace(space)) {
            revert TickTacToken__SpaceAlreadyMarked();
        }
        // To avoid multiple storage reads
        Turn currentPlayerTurn = s_currentTurn;
        Symbol symbol = (currentPlayerTurn == Turn.X_TURN) ? Symbol.X : Symbol.O;
        s_board[space] = symbol;
        s_currentTurn = (currentPlayerTurn == Turn.X_TURN) ? Turn.O_TURN : Turn.X_TURN;
        emit SpaceMarked(space, symbol);
    }

    /**
     * Public
     */

    /**
     * Internal
     */
    function _emptySpace(uint8 space) internal view validSpace(space) returns (bool) {
        return s_board[space] == Symbol.EMPTY;
    }

    /**
     * Private
     */

    /**
     * Getters
     */
    function currentTurn() public view returns (Turn) {
        return s_currentTurn;
    }

    function getBoard() external view returns (Symbol[9] memory) {
        return s_board;
    }

    function getBoardSpace(uint8 space) external view validSpace(space) returns (Symbol) {
        return s_board[space];
    }
}
