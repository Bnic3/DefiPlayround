// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./FlashLoanReceiverBase.sol";
import { Withdrawable } from "./Withdrawable.sol";
import {IMockArbitrage} from "./Interfaces.sol";
 
contract FirstFlashLoan is FlashLoanReceiverBase,Withdrawable{   

    event UpdatedArbitrageContract (address oldArbitrageContract, address newArbitrageContract);

    IMockArbitrage arbitrageContract;
    constructor( address _addressProvider,address _arbitrageContract ) FlashLoanReceiverBase(_addressProvider) {
        arbitrageContract = IMockArbitrage(_arbitrageContract);
    }
    
    

  /**
     * @dev This function must be called only be the LENDING_POOL and takes care of repaying
     * active debt positions, migrating collateral and incurring new V2 debt token debt.
     *
     * @param assets The array of flash loaned assets used to repay debts.
     * @param amounts The array of flash loaned asset amounts used to repay debts.
     * @param premiums The array of premiums incurred as additional debts.
     * @param initiator The address that initiated the flash loan, unused.
     * @param params The byte array containing, in this case, the arrays of aTokens and aTokenAmounts.
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    )
        external
        override
        returns (bool)
    {
        //
        // This contract now has the funds requested.
        // Your logic goes here.
        //
        
        // At the end of your logic above, this contract owes
        // the flashloaned amounts + premiums.
        // Therefore ensure your contract has enough to repay
        // these amounts.
        arbitrageContract.takeArbitrage(assets[0]);

        // approve lending pool to extract debt from the contract.
        for (uint index = 0; index < assets.length; index++) {
            uint debt = amounts[index] + premiums[index];
            ERC20(assets[index]).approve(address(LENDING_POOL), debt);
        }
        return true;
    }

    function _flashLoan(address[] memory assets, uint256[] memory amounts) private {
        address receiverAddress = address(this);
        address onBehalfOf = address(this);
        uint256[] memory modes = new uint256[](assets.length);
        bytes memory params = "";
        uint16 referralCode = 0;

        // 0 = no debt (flash), 1 = stable, 2 = variable
        for (uint256 i = 0; i < assets.length; i++) {
            modes[i] = 0;
        }

        LENDING_POOL.flashLoan(receiverAddress, assets, amounts, modes, onBehalfOf, params, referralCode);
    }

    function flashloan(address _asset, uint256 _amount) public onlyOwner {
        address[] memory assets = new address[](1);
        uint256[] memory amounts = new uint256[](1);
        assets[0] = _asset;
        amounts[0]= _amount;

        _flashLoan(assets, amounts);
    }

    function setArbitrageContract (address _newArbitrageContract) external {
        address _previousArbitrageContract = address(arbitrageContract);
        arbitrageContract = IMockArbitrage(_newArbitrageContract);
        emit UpdatedArbitrageContract (_previousArbitrageContract, _newArbitrageContract);
    }

    function test() public view  returns (address){
        return arbitrageContract.checkSender();
    }
}
