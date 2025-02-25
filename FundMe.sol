// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    //Using the 'PriceConverter' library here for all 'uint256'
    using PriceConverter for uint256;

    uint256 public minimum_usd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
        //Allow users to send $
        //Have a minimum $ sent

        //1. How do we sent ETH to this contract?
        require(msg.value.getConversionRate() >= minimum_usd, "Did not sent enough ETH!");
        //What is a revert?
        //Undo any actions that have been done and send the remaning gas back
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withDrawal() public {}
}

//Oracles: to interact with the outside world or external systems, data feeds API
// 