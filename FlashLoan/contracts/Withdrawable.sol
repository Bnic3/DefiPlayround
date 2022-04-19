// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/* Witdraws stuck assets from a contract */
contract Withdrawable is Ownable {
    using SafeERC20 for ERC20;

    address constant ETHER = address(0);

    event LogWithdrawal(
        address indexed _from,
        address indexed _assetAddress,
        uint256 amount
    );

    function withdraw(address _assetAddress) public onlyOwner {
        uint256 assetBalance;
        if (_assetAddress == ETHER) {
            assetBalance = address(this).balance;
            payable(msg.sender).transfer(assetBalance);
        } else {
            assetBalance = ERC20(_assetAddress).balanceOf(address(this));
            ERC20(_assetAddress).safeTransfer(msg.sender, assetBalance);
        }
        emit LogWithdrawal(msg.sender, _assetAddress, assetBalance);
    }
}
