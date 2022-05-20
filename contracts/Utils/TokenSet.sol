// https://eips.ethereum.org/EIPS/eip-20
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract TokenSet is Ownable{

    mapping(address => address) tokenSet;
    mapping(address => bool) tokenSetExist;

    event tokenSetAdded(
        address indexed nativeToken, 
        address indexed wrappedToken
    ); 
    function addTokenSet(address nativeToken, address wrappedToken) onlyOwner public {
         require(!tokenSetExist[nativeToken], 'EthGateway: Token set exists already');
         // add validation to make sure address is contract

         tokenSetExist[nativeToken] = true; 
         tokenSet[nativeToken] = wrappedToken;

         emit tokenSetAdded(nativeToken, wrappedToken);
    }

    event tokenSetRemoved(
        address indexed nativeToken, 
        address indexed wrappedToken
    ); 

    function removeTokenSet(
        address nativeToken, 
        address wrappedToken
    ) onlyOwner public virtual{

        require(
            tokenSetExist[nativeToken] && tokenSet[nativeToken] == wrappedToken, 
            'Access: Token not in bridge'
         );

        delete tokenSet[nativeToken]; 
        delete tokenSetExist[nativeToken];

        emit tokenSetRemoved(nativeToken, wrappedToken);
    }

    function nativeTokenExist(address nativeToken) public view returns(bool){
        return tokenSetExist[nativeToken];
    }

    function getTokenSet(address nativeToken) public view returns(address, address){
        return (nativeToken, tokenSet[nativeToken]);
    }
}
