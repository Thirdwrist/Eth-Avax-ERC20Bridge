// https://eips.ethereum.org/EIPS/eip-20
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "../Utils/TokenSet.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";



contract EthGateway is Ownable, Pausable , TokenSet{

    address private vault;  // Change name to vault (actual name of contract)
    address private bridge;

    constructor (address _vault, address _bridge) Ownable()
    {
        // set ownable 
        vault = _vault;
        bridge = _bridge;
    }

    event ERC20TokenDeposited(
        address indexed nativeToken,
        address indexed wrappedToken,
        uint amount, 
        address indexed from, 
        address to
     );

    function depositeERC20(
        address nativeToken, 
        address wrappedToken, 
        uint amount
        ) public {
        depositeERC20To(nativeToken, wrappedToken, msg.sender, amount);
    }

    function depositeERC20To(
        address nativeToken, 
        address wrappedToken, 
        address to, 
        uint amount
        ) whenNotPaused public {
        // implement gasstation to collect all fees here and not on wrapped chain

        // is it from list of allowed tokens on native chain. 
        require(tokenSet[nativeToken] == wrappedToken, 'EthGateway: tokenset not supported');

        // send token to escrew
        bool result = IERC20(nativeToken).transferFrom(_msgSender(), vault, amount);
        require(result, 'EthGateway: Token transfer failed');

        emit ERC20TokenDeposited(nativeToken, wrappedToken, amount, _msgSender(), to);
        
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
        address indexed from, 
        address to
     );

    function finalizeWithdrawERC20(
        address nativeToken, 
        address wrappedToken, 
        uint amount
        ) public {
        
        require(msg.sender == bridge, 'EthGateway: Only bridge can perform this function');
        require(tokenSet[nativeToken] == wrappedToken, 'EthGateway: Tokenset not supported');

        // validation machanism to ensure that asset has been truely removed from wrapped chain

        // transfer asset 
        // vault should give this contract infinite ability to transfer asset on its behalf. 
       bool result =  IERC20(nativeToken).transferFrom(vault, msg.sender, amount);

       require(result, 'EthGateway: Releasing token failed');

       emit ERC20TokenWrithdrawalFinalized(nativeToken, wrappedToken, amount, msg.sender, msg.sender);

    }

    function removeTokenSet(address nativeToken,  address wrappedToken) onlyOwner public override {
         require(
             IERC20(nativeToken).balanceOf(vault) == 0,
              'Access: Token has to be empty to remove'
        );
         // NOTICE: might not be able to truely remove token if value was forcely sent to it, 
        // maybe maintain a balance mapping for each token ID
        super.removeTokenSet(nativeToken, wrappedToken);

    }

    function pause() onlyOwner public{
        _pause();
    }

     function unpause() onlyOwner public{
        _unpause();
    }

    function getBridge() public view returns(address) {
        return bridge;
    }

    function getVault() public view returns(address) {
        return vault;
    }


}