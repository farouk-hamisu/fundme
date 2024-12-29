//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19; 

import{Script, console} from "forge-std/Script.sol"; 
import {FundMe} from "../src/FundMe.sol"; 
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol"; 

contract FundFundMe is Script {
  uint256 constant SEND_VALUE = 0.1 ether; 
  function fundFundMe(address mostRecentDeployed) public {
    vm.startBroadcast(); 
    FundMe(payable(mostRecentDeployed)).fund{value:SEND_VALUE}(); 
    vm.stopBroadcast(); 
    console.log("Funded FundMe with %s", SEND_VALUE); 
  }

  function run() external {
    address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid); 
    fundFundMe(mostRecentDeployed); 
  }

 }

 contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentDeployed) public {
      vm.startBroadcast(); 
      FundMe(payable(mostRecentDeployed)).cheaperWithdraw(); 
      vm.stopBroadcast(); 
      console.log("Withdraw FundMe balance"); 
    }
    
    function run() external {
      address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid); 
      withdrawFundMe(mostRecentlyDeployed); 
    }
  }

