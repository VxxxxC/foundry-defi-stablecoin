// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
contract DSCEngine is ReentrancyGuard {
    /////////////////////
    // State Variables //
    /////////////////////
    mapping(address token => address priceFeed) private s_priceFeeds; // Token -> price feed
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited; // User address -> token address
    DecentralizedStableCoin private immutable i_dsc;

    /////////////////////
    //      Event      //
    /////////////////////
    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);

    /////////////////////
    //      Errors     //
    /////////////////////
    error DSCEngine__AmountMustBeMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine__NotAllowedToken();
    error DSCEngine__TransferFailed();

    /////////////////////
    //    Modifiers    //
    /////////////////////

    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__AmountMustBeMoreThanZero();
        }
        _;
    }

    modifier isAollowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__NotAllowedToken();
        }
        _;
    }

    /////////////////////
    //    Functions    //
    /////////////////////
    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    ////////////////////////
    // external Functions //
    ///////////////////////
    function depositCollateralAndMintDsc() external {}

    /**
     * @param tokenCollateralAddress The address of the token to deposit as collateral
     * @param amountCollateral The amount of collateral to deposit
     * @notice follow CEI (Checks-Effects-Interactions) pattern
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAollowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        bool success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDsc() external {}

    function redeemCollateral() external {}

    function mintDes() external {}

    function burnDsc() external {}

    function liquidate() external {}

    function getHealthFactor() external {}
}
