// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// 1. 创建一个收款函数
// 2. 记录投资人并且查看
// 3. 在锁定期内 打到目标值 生产商可以提款
// 4. 在锁定期内，没有达到目标值，投资人在锁定期以后退款

contract FundMe{

    mapping(address => uint256) public funderToAmount;

    uint256 MINIUM_VALUE = 100* 10 ** 18; // USD

    AggregatorV3Interface internal dataFeed;

    uint256 constant TARGET = 1000 * 10 ** 18;


    // 添加事件来跟踪交易状态
    event FundReceived(address indexed from, uint256 amount);

    constructor(){
        // sepolia 
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function fund() external payable  {
        require(convertEthToUsd(msg.value) >= MINIUM_VALUE,"Send more ETH"); // 回退
        funderToAmount[msg.sender] = msg.value;
        emit FundReceived(msg.sender, msg.value);  // 添加事件触发
    }

    
    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    function convertEthToUsd(uint256 ethAmount) internal  view returns (uint256){
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmount * ethPrice/ (10 **8);
    }

    function getFund() external {
        address
    }
}