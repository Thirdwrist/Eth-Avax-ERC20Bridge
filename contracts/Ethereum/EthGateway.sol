// https://eips.ethereum.org/EIPS/eip-20
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "../Utils/TokenSet.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";



contract EthGateway is Pausable , TokenSet{

    address escrew;
    address bridge;

    constructor (address _escrew, address _bridge)
    {
        // set ownable 
        escrew = _escrew;
        bridge = _bridge;
    }

    event ERC20TokenDeposited(
        address indexed nativeToken,
        address indexed wrappedToken,
        uint amount, 
        address indexed sender, 
        address reciever
     );

    function depositeERC20(address nativeToken, address wrappedToken, uint amount) public {
        depositeERC20To(nativeToken, wrappedToken, msg.sender, amount);
    }

    function depositeERC20To(address nativeToken, address wrappedToken, address to, uint amount) whenNotPaused public {
        // implement gasstation to collect all fees here and not on wrapped chain

        // is it from list of allowed tokens on native chain. 
        require(tokenSet[nativeToken] == wrappedToken, 'EthGateway: tokenset not supported');

        // send token to escrew
        bool result = IERC20(nativeToken).transferFrom(msg.sender, escrew, amount);
        require(result, 'EthGateway: Token transfer failed');
        
        // hash the transaction to be used in wrapped bridge 
    }

    /**
    ** TODO 
    * clean up code to use either "to and from" or "sender and reciever" as address names
     */
    event ERC20TokenWrithdrawalFinalized(
        address indexed nativeToken,
        address indexed wrappedToken,
        uint amount, 
        address indexed sender, 
        address reciever
     );

    function finalizeWithdrawERC20(address nativeToken, address wrappedToken, uint amount) onlyBridge public {
        
        require(msg.sender == bridge, 'EthGateway: Only dridge can perform this function');
        require(tokenSet[nativeToken] == wrappedToken, 'EthGateway: Tokenset not supported');

        // validation machanism to ensure that asset has been truely removed from wrapped chain

        // transfer asset 
       bool result =  IERC20(nativeToken).transferFrom(escrew, msg.sender, amount);

       require(result, 'EthGateway: Releasing token failed');

    }


}