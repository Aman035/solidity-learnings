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
    error TickTacToken__Unauthorized();
    error TickTacToken__InvalidPlayer();

    /**
     * Interfaces
     */

    /**
     * Type Declarations
     */
    enum Symbol {
        EMPTY,
        X,
        O
    }
    enum Turn {
        X_TURN,
        O_TURN
    }

    /**
     * State Variables
     */
    address private immutable i_owner;
    address private immutable i_playerX;
    address private immutable i_playerO;
    Turn private s_currentTurn;
    Symbol[9] private s_board;

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
    constructor(address playerX, address playerO) {
        i_owner = msg.sender;
        i_playerX = playerX;
        i_playerO = playerO;
    }

    /**
     * External
     */
    function markSpace(uint8 space) external validSpace(space) {
        if (!_validPlayer()) {
            revert TickTacToken__InvalidPlayer();
        }
        if (!_emptySpace(space)) {
            revert TickTacToken__SpaceAlreadyMarked();
        }
        // To avoid multiple storage reads
        Turn currentPlayerTurn = s_currentTurn;
        if (
            (msg.sender == i_playerX && currentPlayerTurn != Turn.X_TURN)
                || (msg.sender == i_playerO && currentPlayerTurn != Turn.O_TURN)
        ) {
            revert TickTacToken__NotYourTurn();
        }

        Symbol symbol = (currentPlayerTurn == Turn.X_TURN) ? Symbol.X : Symbol.O;
        s_board[space] = symbol;
        s_currentTurn = (currentPlayerTurn == Turn.X_TURN) ? Turn.O_TURN : Turn.X_TURN;

        emit SpaceMarked(space, symbol);
    }

    function resetBoard() external {
        if (msg.sender != i_owner) {
            revert TickTacToken__Unauthorized();
        }
        delete s_board; // sets with dafault value in array
    }

    /**
     * Public
     */

    /**
     * Internal
     */

    /**
     * Private
     */

    function _emptySpace(uint8 space) private view returns (bool) {
        return s_board[space] == Symbol.EMPTY;
    }

    function _validPlayer() private view returns (bool) {
        return msg.sender == i_playerX || msg.sender == i_playerO;
    }

    function _convertSymbolToAddress(Symbol symbol) private view returns (address) {
        if (symbol == Symbol.X) {
            return i_playerX;
        } else if (symbol == Symbol.O) {
            return i_playerO;
        }
        return address(0);
    }

    /**
     * @dev Returns the winner symbol of a row, if no winner then returns Symbol.EMPTY
     * @param row Row number
     */
    function _row(uint8 row) private view returns (Symbol) {
        uint8 space = row * 3;
        if (
            s_board[space] != Symbol.EMPTY && s_board[space] == s_board[space + 1]
                && s_board[space] == s_board[space + 2]
        ) {
            return s_board[space];
        }
        return Symbol.EMPTY;
    }

    /**
     * @dev Returns the winner symbol of a col, if no winner then returns Symbol.EMPTY
     * @param col Col number
     */
    function _col(uint8 col) private view returns (Symbol) {
        uint8 space = col;
        if (
            s_board[space] != Symbol.EMPTY && s_board[space] == s_board[space + 3]
                && s_board[space] == s_board[space + 6]
        ) {
            return s_board[space];
        }
        return Symbol.EMPTY;
    }

    function _diag() private view returns (Symbol) {
        uint8 space = 0;
        if (
            s_board[space] != Symbol.EMPTY && s_board[space] == s_board[space + 4]
                && s_board[space] == s_board[space + 8]
        ) {
            return s_board[space];
        }
        return Symbol.EMPTY;
    }

    function _antiDiag() private view returns (Symbol) {
        uint8 space = 2;
        if (
            s_board[space] != Symbol.EMPTY && s_board[space] == s_board[space + 2]
                && s_board[space] == s_board[space + 4]
        ) {
            return s_board[space];
        }
        return Symbol.EMPTY;
    }

    /**
     * Getters
     */

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getPlayerX() external view returns (address) {
        return i_playerX;
    }

    function getPlayerO() external view returns (address) {
        return i_playerO;
    }

    function currentTurn() external view returns (address) {
        return s_currentTurn == Turn.X_TURN ? i_playerX : i_playerO;
    }

    function getBoard() external view returns (Symbol[9] memory) {
        return s_board;
    }

    function getBoardSpace(uint8 space) external view validSpace(space) returns (Symbol) {
        return s_board[space];
    }

    function getWinner() external view returns (address) {
        Symbol[8] memory wins = [_row(0), _row(1), _row(2), _col(0), _col(1), _col(2), _diag(), _antiDiag()];
        for (uint256 i; i < wins.length; ++i) {
            Symbol win = wins[i];
            if (win == Symbol.X || win == Symbol.O) return _convertSymbolToAddress(win);
        }
        return address(0);
    }
}
