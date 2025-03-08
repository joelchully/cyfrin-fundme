// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    //Using the 'PriceConverter' library here for all 'uint256'
    using PriceConverter for uint256;

    //constants
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    //only defined once we can use immutable
    address public immutable i_owner;

    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }
    
    function fund() public payable {
        //Allow users to send $
        //Have a minimum $ sent

        //1. How do we sent ETH to this contract?
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Did not sent enough ETH!");
        //What is a revert?
        //Undo any actions that have been done and send the remaning gas back
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function withDrawal() public onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset array
        funders = new address[](0);
        //actually withdraw the funds
        //3 different ways

        // //Transfer
        // payable(msg.sender).transfer(address(this).balance);
        // //Send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed");
        //Call
        (bool callSuccess,) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    //function Modifiers in Solidity
    modifier onlyOwner() {
        require(msg.sender == i_owner, "You are not the owner");
        //This means that wherever the modifier is used 
        //it should first check the 'require' condition and then execute the remaining peice of code
        _;
    }

    //What happens if someone sends this contract ETH without calling fund() 
    receive() external payable {
        fund();
    }
    fallback() external payable { 
        fund();
    }
}

//Oracles: to interact with the outside world or external systems, data feeds API
// 