//SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

//import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    mapping(address => uint256) public addressToAmountFunded;

    uint256 usd2eth;

    function getUSD2ETH() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * (10000000000));//10000000000
    }
    
    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
        (,int256 answer,,,) = priceFeed.latestRoundData();
         // ETH/USD rate in 18 digit 
         return uint256(answer * 10000000000);
    }
    // 1000000000
    function getConversionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }

    //payable - fxn use for payments 
    function fund() public payable{
        uint256 minUSD = 50 * 10 ** 18;

        require(getConversionRate(msg.value) >= minUSD, "WRONG ammount");
        addressToAmountFunded[msg.sender] += msg.value;
    }
}

//3352.57000000

// everything default to wei
// msg.sender and msg.value -- keyword in every trx
// msg.sender = sender of fxn call
// msg.value is how much  value sender send   
