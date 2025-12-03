// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title MockFailedTransfer
 * @notice Mock ERC20 that returns false on transfer to test failure branches
 */
contract MockFailedTransfer is ERC20 {
    constructor() ERC20("Mock Failed Transfer", "MFT") {
        _mint(msg.sender, 1000000 ether);
    }

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }

    // Override to return false instead of reverting
    function transfer(address, uint256) public pure override returns (bool) {
        return false;
    }
}
