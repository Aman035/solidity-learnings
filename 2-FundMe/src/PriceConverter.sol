// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// This is same as defining the interface ( used for getting ABI )
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Note - Library can't have storage variables
library PriceConverter {
    // Library functions most of the time are internal
    // If Public we would need to deploy library
    // If private then no contract can use the library
    // @returns price of 1 ETH in USD
    function fetchPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // returns price in this format USD Price * 1e8
        // this is done as solidity does not work with decimals
        // so we can say that price is acurate till 8 decimal places
        (, int256 price,,,) = priceFeed.latestRoundData();

        // typecast
        // we return price of 1 ETH in USD with 1e18
        return uint256(price * 1e10);
    }

    // Returns price of x AMOUNT of ETH in USD ( with 1e18 )
    function convertEthToUSD(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 price = fetchPrice(priceFeed);
        // ethAmount was actually in WEI so divided by 1e18
        return (ethAmount * price) / 1e18;
    }
}
