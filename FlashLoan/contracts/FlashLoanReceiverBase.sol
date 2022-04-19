// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IFlashLoanReceiver,ILendingPoolAddressesProvider,ILendingPool} from "./Interfaces.sol";

abstract contract FlashLoanReceiverBase is IFlashLoanReceiver{
  using SafeERC20 for ERC20;
  ILendingPoolAddressesProvider public immutable ADDRESSES_PROVIDER;
  ILendingPool public immutable LENDING_POOL;

  constructor(address provider){
    ADDRESSES_PROVIDER = ILendingPoolAddressesProvider(provider);
    LENDING_POOL = ILendingPool(ILendingPoolAddressesProvider(provider).getLendingPool());
  }

  receive() payable external {}
}
