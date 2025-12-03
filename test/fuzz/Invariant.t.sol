// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";

contract Invariant is Test {
    DeployDSC deployer;
    DSCEngine dscEngine;
    HelperConfig helperConfig;
    DecentralizedStableCoin dsc;
    address weth;
    address wbtc;

    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dscEngine, helperConfig) = deployer.run();
        (,, weth, wbtc,) = helperConfig.activeNetworkConfig();

        targetContract(address(dscEngine));
    }

    function invariant_protocolMustHaveMoreThanTotalSupply() public view {
        // get the value of all the collateral in the protocol
        // compare it to all the debt (totalSupply of DSC)        
        uint256 totalSupply = dsc.totalSupply();
        console.log("Total DSC Supply:", totalSupply);

        uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dscEngine));
        uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(dscEngine));
 
        uint256 wethValue = dscEngine.getUsdValue(address(weth), totalWethDeposited);
        uint256 wbtcValue = dscEngine.getUsdValue(address(wbtc), totalWbtcDeposited);

        console.log("Total WETH Value in USD:", wethValue);
        console.log("Total WBTC Value in USD:", wbtcValue);

        assert(wethValue + wbtcValue >= totalSupply);
    }
}
