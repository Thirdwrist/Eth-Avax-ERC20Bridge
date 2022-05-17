// https://eips.ethereum.org/EIPS/eip-20
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";


contract TokenSet is Ownable{

    mapping(address => address) tokenSet;
    mapping(address => bool) tokenSetExist;

    event tokenSetAdded(address indexed nativeToken, address indexed wrappedToken); 
    function addTokenSet(address nativeToken, address wrappedToken) onlyOwner public {
         require(!tokenSetExist[nativeToken], 'EthGateway: Token set exits already');

         tokenSetExist[nativeToken] = true; 
         tokenSet[nativeToken] = wrappedToken;

         emit tokenSetAdded(nativeToken, wrappedToken);
    }

    event tokenSetRemoved(address indexed nativeToken, address indexed wrappedToken); 

    function removeTokenSet(address nativeToken, address wrapppedToken) onlyOnwer public{
        require(
            tokenSetExist[nativeToken] && tokenSet[nativeToken] == wrapppedToken, 
            'EthGateway: Token not in bridge'
         );
         require(
             IERC20(nativeToken).balanceOf(account) == 0,
              'EthGateway: Token has to be empty to remove'
            );

        delete tokenSet[nativeToken]; 
        delete tokenSetExist[nativeToken];

        emit tokenSetRemoved(nativeToken, wrappedToken);
    }
}
