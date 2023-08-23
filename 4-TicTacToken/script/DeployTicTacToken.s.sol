// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {TicTacToken} from "../src/TicTacToken.sol";

contract DeployTicTacToken is Script {
    address private constant PLAYER_X = 0x28F1C7B4596D9db14f85c04DcBd867Bf4b14b811;
    address private constant PLAYER_O = 0x35B84d6848D16415177c64D64504663b998A6ab4;

    function run() external returns (TicTacToken, address, address) {
        vm.startBroadcast();
        TicTacToken ttt = new TicTacToken(PLAYER_X, PLAYER_O);
        vm.stopBroadcast();
        return (ttt, PLAYER_X, PLAYER_O);
    }
}
