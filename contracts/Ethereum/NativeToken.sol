// https://eips.ethereum.org/EIPS/eip-20
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NativeToken is ERC20 {
    
    constructor() ERC20('NativeToken', 'NVT'){
        _mint(_msgSender(), 100**18);
    }

}
