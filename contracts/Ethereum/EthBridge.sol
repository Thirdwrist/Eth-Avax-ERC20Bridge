// https://eips.ethereum.org/EIPS/eip-20
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";



contract EthBridge is Pausable {

    address escrew;
    mapping(address => address) tokenSet;
    mapping(address => bool) tokenSetExist;

    constructor (address _escrew)
    {
        escrew = _escrew;
    }

    event ERC20TokenDeposited(
        address indexed nativeToken,
        address indexed wrappedToken,
        uint amount, 
        address indexed sender, 
        address reciever
     );

    function depositeERC20(address token, address wrappedToken, uint amount) whenNotPaused public {

        // implement gasstation to collect all fees here and not on wrapped chain

        // is it from list of allowed tokens on native chain. 
        require(tokenSet[token] == wrappedToken, 'tokenset not supported');

        // send token to escrew
        IERC20(token).transferFrom(msg.sender, escrew, amount);

        // hash the transaction to be used in wrapped bridge 
    }

    function depositeERC20To(address token, address wrappedToken, address to, uint amount) whenNotPaused public {
        // same as depositeERC20, only difference the to address
    }

    
    event ERC20TokenWrithdrawalFinalized(
        address indexed nativeToken,
        address indexed wrappedToken,
        uint amount, 
        address indexed sender, 
        address reciever
     );

    function finalizeWithdrawERC20(address nativeToken, address wrappedToken, uint amount) public {
        require(tokenSet[token] == wrappedToken, 'tokenset not supported');

        // validation machanism to ensure that asset has been truely removed from wrapped chain

        // transfer asset 
        IERC20(nativeToken).transferFrom(escrew, msg.sender, amount);

    }

    event tokenSetAdded(address indexed nativeToken, address indexed wrappedToken); 

    function addTokenSet(address nativeToken, address wrappedToken) onlyOwner public {
         require(!tokenSetExist[nativeToken], 'Token set exits already');

         tokenSetExist[nativeToken] = true; 
         tokenSet[nativeToken] = wrappedToken;

         emit tokenSetAdded(nativeToken, wrappedToken);
    }

    event tokenSetRemoved(address indexed nativeToken, address indexed wrappedToken); 

    function removeTokenSet(address nativeToken, address wrapppedToken) onlyOnwer public{
        require(
            tokenSetExist[nativeToken] && tokenSet[nativeToken] == wrapppedToken, 
            'Token not in bridge'
         );
         require(
             IERC20(nativeToken).balanceOf(account) == 0,
              'Token has to be empty to remove'
            );

        delete tokenSet[nativeToken]; 
        delete tokenSetExist[nativeToken];

        emit tokenSetRemoved(nativeToken, wrappedToken);
    }
}