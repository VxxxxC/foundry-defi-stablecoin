// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

/**
 * @title DSCEngine
 * @author VxxxxC
 *
 * The system is designed to be as minial as possible, and have the tokens maintain a 1 token = $1 peg.
 * This stablecoin has the properties:
 * - Exogenous Collateral
 * - Dollar Pegged
 * - Algoritmically stable
 *
 * It is similar to DAI if DAI had no governance, no fees, and was only backed by wETH and wBTC.
 *
 * @notice This contract is the core of the DSC system, It handles all the logic for mining and redeeming DSC,
 * as well as depositing and withdrawing collateral.
 * @notice This is contract is VERY loosely based on the MakerDAO DSS (DAI Stablecoin System).
 */
contract DSCEngine {
    function depositCollateralAndMintDsc() external {}

    function redeemCollateralForDex() external {}

    function burnDsc() external {}

    function liquidate() external {}
}
