//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "../Utils/TokenSet.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

interface Mintable {
  function mint(address usr, uint256 wad) external;
  function burn(uint256 wad) external;
}

contract AvaxGateway  is Pausable, TokenSet{

    address bridge; 

    constructor(address _bridge){

        // set ownable 
        bridge = _bridge;
    }

    function withdrawERC20(
        address nativeToken, 
        address wrappedToken, 
        uint amount
        ) public {

        withdrawERC20To(msg.sender, nativeToken, wrappedToken, amount);

    }

    event ERC20WithdrawalInitiated(
        address indexed from,
        address indexed to, 
        address indexed wrappedToken, 
        uint amount
    );

    function withdrawERC20To(
        address to, 
        address nativeToken, 
        address wrappedToken, 
        uint amount
        ) public {

        require(tokenSet[nativeToken] == wrappedToken, 'AvaxGateway: tokenset not supported');

        Mintable(wrappedToken).burn(amount);

        emit ERC20WithdrawalInitiated(msg.sender, to, wrappedToken, amount);
    }

    event ERC20TokenDepositeCompleted(
        address nativeToken, 
        address wrappedToken, 
        uint amount, 
        address from,
        address to
    );

    function completeERC20Deposite(
        address from, 
        address to, 
        address nativeToken,
        address wrappedToken, 
        uint amount
        ) public {

        require(msg.sender == bridge, 'AvaxGateway: Only bridge can perform this action');
        require(tokenSet[nativeToken] == wrappedToken, 'AvaxGateway: Tokenset not supported');

        Mintable(wrappedToken).mint(to, amount);

        emit ERC20TokenDepositeCompleted(nativeToken, wrappedToken, amount, from, to);

    }

     function removeTokenSet(address nativeToken,  address wrappedToken) onlyOwner public override {
         require(
             IERC20(wrappedToken).totalSupply() == 0,
              'Access: Token has to be empty to remove'
        );
         // NOTICE: might not be able to truely remove token if value was forcely sent to it, 
        // maybe maintain a balance mapping for each token ID
        super.removeTokenSet(nativeToken, wrappedToken);

    }

}