//SDX-LINCENSE-identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;
    uint256 constant SEND_VALUE = 10 ether; 
    address alice = makeAddr("alice"); 
    uint256 constant STARTING_BALANCE = 10 ether; 
    uint256 constant GAS_PRICE = 1; 
    modifier funded() {
      vm.prank(alice); 
      fundMe.fund{value: SEND_VALUE}(); 
      assert(address(fundMe).balance > 0); 
      _;
    }

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(alice, STARTING_BALANCE); 
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log(fundMe.i_owner());
        console.log(address(this));
        console.log(msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
    function testFundFailsWithoutEnoughETH() public {
      vm.expectRevert(); // <- The next line after this one should revert ! if not test failed
      fundMe.fund(); // <- We send zero values
    }
    function testFundUpdatesFundDataStructure() public {
      vm.prank(alice); 
      fundMe.fund{value: 10 ether}(); 
      uint256 amountFunded = fundMe.getAddressToAmountFunded(alice); 
      assertEq(amountFunded, SEND_VALUE); 
    }
    function testAddsFunderToArrayOfFunders() public {
      vm.startPrank(alice); 
      fundMe.fund{value: SEND_VALUE}(); 
      vm.stopPrank(); 
      address funder = fundMe.getFunder(0); 
      assertEq(funder, alice); 
    }
    function testOnlyOwnerCanWithdraw() public funded {
      vm.expectRevert(); 
      vm.prank(alice); 
      fundMe.withdraw(); 
    }
    function testWithdrawFromASingleFunder() public funded {
      uint256 startingFundBalance = address(fundMe).balance; 
      uint256 startingOwnerBalance = fundMe.getOwner().balance; 

      vm.txGasPrice(GAS_PRICE); 
      uint256 gasStart = gasleft(); 

      vm.startPrank(fundMe.getOwner()); 
      fundMe.withdraw(); 
      vm.stopPrank(); 

      uint256 gasEnd = gasleft(); 
      uint256 gasUsed = (gasStart- gasEnd) * tx.gasprice; 
      console.log("Withdraw consumed: % gas", gasUsed); 
      uint256 endingFundMeBalance = address(fundMe).balance; 
      uint256 endingOwnerBalance = fundMe.getOwner().balance; 
      assertEq(endingFundMeBalance, 0); 
      assertEq(
        startingFundBalance + startingOwnerBalance, 
        endingOwnerBalance
      ); 
    }
    function testWithdrawFromMultipleFunders() public funded {
      uint160 numberOfFunders = 10; 
      uint160 startingFunderIndex = 1; 
      for(uint160 i = startingFunderIndex; i < numberOfFunders + startingFunderIndex; i++){
        hoax(address(i), SEND_VALUE); 
        fundMe.fund{value: SEND_VALUE}(); 
      }
      uint256 startingFundMeBalance = address(fundMe).balance; 
      uint256 startingOwnerBalance = fundMe.getOwner().balance; 

      vm.startPrank(fundMe.getOwner()); 
      fundMe.withdraw(); 
      vm.stopPrank(); 

      assert(address(fundMe).balance == 0); 
      assert(startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance); 
      assert((numberOfFunders +1) * SEND_VALUE == fundMe.getOwner().balance - startingOwnerBalance); 
    }
    function testPrintStorageData() public {
      for(uint256 i = 0; i < 3; i++){
        bytes32 value = vm.load(address(fundMe), bytes32(i)); 
        console.log("value at location", i, ":"); 
        console.logBytes32(value); 
      }
      console.log("PriceFeed address:", address(fundMe.getPriceFeed())); 
    }
}
