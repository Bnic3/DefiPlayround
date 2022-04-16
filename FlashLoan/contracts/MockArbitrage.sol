// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./Withdrawable.sol";

contract MockArbitrage is Withdrawable {
  using SafeERC20 for ERC20;
  event ArbitrageTaken(address taker, uint takerBalance, uint amountTaken);
  event RequiredFundsChanged(uint previousRequiredFunds, uint newRequiredFunds);

  uint public requiredFunds;

  constructor(uint _requiredFunds) {
    requiredFunds = _requiredFunds;
  }

  function takeArbitrage(address _assetAddress) external {
    address _taker = msg.sender;
    uint _takerBalance = ERC20(_assetAddress).balanceOf(_taker);
    require( _takerBalance >= requiredFunds, "Insufficient Funds to take Arbitrage");

    uint _assetBalance = ERC20(_assetAddress).balanceOf(address(this));
    ERC20(_assetAddress).safeTransfer(_taker,_assetBalance);
    emit ArbitrageTaken(_taker, _takerBalance, _assetBalance);    
  }

  function setRequiredFunds(uint _requiredFunds) external{
    uint _previousRequiredFunds = requiredFunds;
    requiredFunds = _requiredFunds;
    emit RequiredFundsChanged(_previousRequiredFunds, _requiredFunds);
  }
}