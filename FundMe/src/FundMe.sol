// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// This is same as defining the interface ( used for getting ABI )
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

// Custom Errors
// These were introduced with 0.8.4 and are quite new
// Gas Optimized as compared to error strings in require
error FundMe__NotOwner();

// Min Contribution amount is in USD and requires fetching the price from oracle
contract FundMe {
    // Using Our Library for uint ie 1st input will be the uint we use the functions for
    using PriceConverter for uint256;

    // State Variables
    uint256 public constant MINIMUM_USD = 5e18;
    address private i_owner;
    address[] private s_funders;
    mapping(address => uint256) public s_addressToAmountFunded;
    AggregatorV3Interface private s_priceFeed;

    // Events ( We don't have any events in this contract )

    // Modifiers
    modifier onlyOwner() {
        // Using custom error rather than require(msg.sender == owner);
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    // Functions Order:
    //// constructor
    //// receive
    //// fallback
    //// external
    //// public
    //// internal
    //// private
    //// view / pure ie the getters

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    // Handles the case when someone accidently sends eth to contract 
    receive() external payable {
        fund();
    }

    // Handles the case when someone calls our contract with non-defined fn or with some data
    fallback() external payable {
        fund();
    }

    function fund() public payable {
        require(msg.value.convertEthToUSD(s_priceFeed) >= MINIMUM_USD, "amount less than min. amount");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public onlyOwner {
        // can be made unchecked for gas optimization
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        // reset to empty array
        s_funders = new address[](0);

        // Diff ways to transfer ETH
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // // call
        // ( LOWLEVEL - Recommeded way to transfer )
        // returns success & bytes data
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}(""); // ("") specify empty fn
        require(callSuccess, "Call failed"); // custom error can be used here
    }

    /** Getter Functions */

    /**
     * @notice Gets the amount that an address has funded
     *  @param fundingAddress the address of the funder
     *  @return the amount funded
     */
    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
