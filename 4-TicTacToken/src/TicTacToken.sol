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

    struct Game {
        uint8 turns;
        Symbol[9] board;
        address playerX;
        address playerO;
    }

    /**
     * State Variables
     */
    address private immutable i_owner;
    mapping(uint256 => Game) private s_games;
    mapping(address => uint256) private s_winCount;
    mapping(address => uint256) private s_points;
    uint256 private s_nextGameId;

    /**
     * Events
     */
    event SpaceMarked(uint8 indexed space, Symbol symbol);

    /**
     * Modifiers
     */
    // uint8 to save gas and since it goes from 0 to 8
    modifier validSpace(uint8 space) {
        if (space > 8) {
            revert TicTacToken__InvalidSpace();
        }
        _;
    }

    /**
     * Functions
     */

    constructor() {
        i_owner = msg.sender;
    }

    /**
     * External
     */
    function addGame(address playerX, address playerO) external {
        s_games[s_nextGameId].playerX = playerX;
        s_games[s_nextGameId].playerO = playerO;
        ++s_nextGameId;
    }

    function markSpace(uint256 gameId, uint8 space) external validSpace(space) {
        if (!_validPlayer(gameId)) {
            revert TickTacToken__InvalidPlayer();
        }
        if (!_emptySpace(gameId, space)) {
            revert TickTacToken__SpaceAlreadyMarked();
        }
        if (getCurrentTurn(gameId) != msg.sender) {
            revert TickTacToken__NotYourTurn();
        }

        Symbol symbol = _convertPlayerToSymbol(gameId, msg.sender);
        s_games[gameId].board[space] = symbol;
        ++s_games[gameId].turns;

        if (getWinner(gameId) != address(0)) {
            ++s_winCount[getWinner(gameId)];
            s_points[getWinner(gameId)] += _pointsEarned(gameId);
        }

        emit SpaceMarked(space, symbol);
    }

    function resetBoard(uint256 gameId) external {
        if (msg.sender != i_owner) {
            revert TickTacToken__Unauthorized();
        }
        delete s_games[gameId].board; // sets with dafault value in array
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

    function _emptySpace(uint256 gameId, uint8 space) private view returns (bool) {
        return s_games[gameId].board[space] == Symbol.EMPTY;
    }

    function _validPlayer(uint256 gameId) private view returns (bool) {
        Game memory game = s_games[gameId];
        return msg.sender == game.playerX || msg.sender == game.playerO;
    }

    function _convertSymbolToPlayer(uint256 gameId, Symbol symbol) private view returns (address) {
        Game memory game = s_games[gameId];
        return symbol == Symbol.X ? game.playerX : (symbol == Symbol.O ? game.playerO : address(0));
    }

    function _convertPlayerToSymbol(uint256 gameId, address player) private view returns (Symbol) {
        Game memory game = s_games[gameId];
        return player == game.playerX ? Symbol.X : (player == game.playerO ? Symbol.O : Symbol.EMPTY);
    }

    function _pointsEarned(uint256 gameId) private view returns (uint256) {
        Game memory game = s_games[gameId];
        uint256 moves;
        if (getWinner(gameId) == game.playerX) {
            moves = (game.turns + 1) / 2;
        }
        if (getWinner(gameId) == game.playerO) {
            moves = game.turns / 2;
        }
        return 600 - (moves * 100);
    }

    /**
     * @dev Returns the winner symbol of a row, if no winner then returns Symbol.EMPTY
     * @param row Row number
     */
    function _row(uint256 gameId, uint8 row) private view returns (Symbol) {
        Symbol[9] memory board = s_games[gameId].board;
        uint8 space = row * 3;
        if (board[space] != Symbol.EMPTY && board[space] == board[space + 1] && board[space] == board[space + 2]) {
            return board[space];
        }
        return Symbol.EMPTY;
    }

    /**
     * @dev Returns the winner symbol of a col, if no winner then returns Symbol.EMPTY
     * @param col Col number
     */
    function _col(uint256 gameId, uint8 col) private view returns (Symbol) {
        Symbol[9] memory board = s_games[gameId].board;
        uint8 space = col;
        if (board[space] != Symbol.EMPTY && board[space] == board[space + 3] && board[space] == board[space + 6]) {
            return board[space];
        }
        return Symbol.EMPTY;
    }

    function _diag(uint256 gameId) private view returns (Symbol) {
        Symbol[9] memory board = s_games[gameId].board;
        uint8 space = 0;
        if (board[space] != Symbol.EMPTY && board[space] == board[space + 4] && board[space] == board[space + 8]) {
            return board[space];
        }
        return Symbol.EMPTY;
    }

    function _antiDiag(uint256 gameId) private view returns (Symbol) {
        Symbol[9] memory board = s_games[gameId].board;
        uint8 space = 2;
        if (board[space] != Symbol.EMPTY && board[space] == board[space + 2] && board[space] == board[space + 4]) {
            return board[space];
        }
        return Symbol.EMPTY;
    }

    /**
     * Getters
     */

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getPlayerX(uint256 gameId) external view returns (address) {
        return s_games[gameId].playerX;
    }

    function getPlayerO(uint256 gameId) external view returns (address) {
        return s_games[gameId].playerO;
    }

    function getCurrentTurn(uint256 gameId) public view returns (address) {
        Game memory game = s_games[gameId];
        return game.turns % 2 == 0 ? game.playerX : game.playerO;
    }

    function getBoard(uint256 gameId) external view returns (Symbol[9] memory) {
        return s_games[gameId].board;
    }

    function getBoardSpace(uint256 gameId, uint8 space) external view validSpace(space) returns (Symbol) {
        return s_games[gameId].board[space];
    }

    function getWinner(uint256 gameId) public view returns (address) {
        Symbol[8] memory wins = [
            _row(gameId, 0),
            _row(gameId, 1),
            _row(gameId, 2),
            _col(gameId, 0),
            _col(gameId, 1),
            _col(gameId, 2),
            _diag(gameId),
            _antiDiag(gameId)
        ];
        for (uint256 i; i < wins.length; ++i) {
            Symbol win = wins[i];
            if (win == Symbol.X || win == Symbol.O) return _convertSymbolToPlayer(gameId, win);
        }
        return address(0);
    }
}
