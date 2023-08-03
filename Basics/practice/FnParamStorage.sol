// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract FunctionParamStorage {
    string private name;

    // Using callData ( good for gas opt. as compared to memory but we cannot change the param)
    function setNameByCallData(string calldata _name) public {
        // This will throw error
        // _name = "Random name";
        name = _name;
    }

    function setNameByMemory(string memory _name) public {
        name = _name;
    }

    // External or public function can't declare param as storage ( obv they can't pass refernce params )
    // function setNameByStorage(string storage _name) public {
    //     name = _name;
    // }

    // This works for internal and privat efn only ( obv as u can pass storage ref internally in contract )
    function setNameByStorage(string storage _name) private {
        name = _name;
    }

    // Functions can't return calldata type for storage types
    // function getNamebyCallData() public view returns(string calldata) {
    //     return name;
    // }

    // But Something like this works ( obv )
    function getNamebyCallData(
        string calldata _name
    ) public view returns (string calldata) {
        return _name;
    }

    function getNameByMemory() public view returns (string memory) {
        return name;
    }

    // External Fn can't return storage ( obv passing storage ref on external fn is not possible )
    // function getNameByStorage() public view returns (string storage) {
    //     return name;
    // }

    // But it works for internal and priv functions
    // It actually makes sense since internally since we want to pass direct storage reference
    function _getNameInternal() internal view returns (string storage) {
        return name;
    }
}
