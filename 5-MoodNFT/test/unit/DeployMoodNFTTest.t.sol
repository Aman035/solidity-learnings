// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MoodNFT} from "../../src/MoodNFT.sol";
import {DeployMoodNFT} from "../../script/DeployMoodNFT.s.sol";

contract DeployMoodNFTTest is Test {
    DeployMoodNFT deployMoodNFT;

    function setUp() public {
        deployMoodNFT = new DeployMoodNFT();
    }

    function testDeployMoodNFTDeploysNewMoodNFTInstance() public {
        deployMoodNFT.run();
    }

    function testEncodeSvgToBase64() public {
        string memory svg = vm.readFile("./images/happy.svg");
        string memory expectedUri =
            "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxjaXJjbGUgY3g9IjEwMCIgY3k9IjEwMCIgZmlsbD0ieWVsbG93IiByPSI3OCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIi8+CiAgPGcgY2xhc3M9ImV5ZXMiPgogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4KICAgIDxjaXJjbGUgY3g9IjEyNyIgY3k9IjgyIiByPSIxMiIvPgogIDwvZz4KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+Cjwvc3ZnPg==";
        assertEq(deployMoodNFT.encodeSvgToBase64(svg), expectedUri);
    }
}
