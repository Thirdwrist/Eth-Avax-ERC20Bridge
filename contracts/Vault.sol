//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Vault is Ownable{


  event Approve(address indexed token, address indexed spender, uint256 value);

  constructor() Ownable() {

  }

  function approve(
    address nativeToken,
    address spender,
    uint256 value
  ) external onlyOwner {

    emit Approve(nativeToken, spender, value);

    IERC20(nativeToken).approve(spender, value);
  }
}