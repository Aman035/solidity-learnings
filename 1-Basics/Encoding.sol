// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract Encoding {
    /****************** COMBINE STRING **************************/

    /**
     * 1. Using string.concat ( available after 0.8.13 only )
     * 2. Using abi.encodePacked
     * 3. Using abi.enocde ( not preferred )
     */

    function combineStringUsingConcat() public pure returns (string memory) {
        return string.concat("Hey", " There");
    }

    function combineStringUsingPackedEncoding()
        public
        pure
        returns (string memory)
    {
        return string(abi.encodePacked("Hey", " There"));
    }

    function combineStringUsingEncoding() public pure returns (string memory) {
        /**
         * THIS DOES NOT WORK
         * REASON - abi.encode encodes a string to bytes memory with prefix ( packed does it without prefix and is a compressed form
         */
        // return string(abi.encode("Hey" , " There"));

        bytes memory str1 = abi.encode("Hey");
        bytes memory str2 = abi.encode(" There");
        bytes memory combined = new bytes(str1.length + str2.length);

        for (uint256 i = 0; i < str1.length; i++) {
            combined[i] = str1[i];
        }

        for (uint256 i = 0; i < str2.length; i++) {
            combined[str1.length + i] = str2[i];
        }

        return string(combined);
    }

    /*********************** PACKED ENCODE STRING ************************/

    // https://forum.openzeppelin.com/t/difference-between-abi-encodepacked-string-and-bytes-string/11837
    // This is great if you want to save space, not good for calling functions.
    // You can sort of think of it as a compressor of abi.encode
    function packedEncodeString() public pure returns (bytes memory) {
        return abi.encodePacked("Hey There");
    }

    // This fn returns the same output as above, but its just a typecast whereas above one is a compression encoding
    function typeCastString() public pure returns (bytes memory) {
        return bytes("Hey There");
    }

    /********************** ENCODE DECODE STRING *********************************/

    // You'd use this to make calls to contracts
    function encodeString() public pure returns (bytes memory) {
        bytes memory someString = abi.encode("some string");
        return someString;
    }

    // Strings encoded using abi.encode can be decoded ( THIS DOES NOT WORK WITH PACKED ENCODING )
    function decodeString() public pure returns (string memory) {
        string memory someString = abi.decode(encodeString(), (string));
        return someString;
    }

    function multiEncode() public pure returns (bytes memory) {
        bytes memory someString = abi.encode("some string", "it's bigger!");
        return someString;
    }

    function multiDecode() public pure returns (string memory, string memory) {
        (string memory someString, string memory someOtherString) = abi.decode(
            multiEncode(),
            (string, string)
        );
        return (someString, someOtherString);
    }

    /******************* ENCODE DECODE PACKED STRING **************************/

    function multiEncodePacked() public pure returns (bytes memory) {
        bytes memory someString = abi.encodePacked(
            "some string",
            "it's bigger!"
        );
        return someString;
    }

    // This doesn't work!
    function multiDecodePacked() public pure returns (string memory) {
        string memory someString = abi.decode(multiEncodePacked(), (string));
        return someString;
    }

    // This does!
    // Gas: 22313
    function multiStringCastPacked() public pure returns (string memory) {
        string memory someString = string(multiEncodePacked());
        return someString;
    }

    /**
    * WE KNOW TO CALL A CONTRACT WE NEED CONTRACT ADDRESS & ITS ABI
    * abi.encode allows us to have abi for specific fn which we can just call if we know the contract address
    * This is used in call and delegateCall
    */

    function withdraw(address recentWinner) public {
        // Here data is empty but ususally it would be populated using encoding
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        require(success, "Transfer Failed");
    }
}
