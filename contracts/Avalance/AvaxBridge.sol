//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract AvaxBridge{
    function depositeERC20(address token, address account, uint amount) public {
        // is it from list of allowed tokens on native chain. 
        // should have a map of tokens that are allowed, thier native to thier wrapped equivalent. (check immappable used in renproject)
    
    }
}