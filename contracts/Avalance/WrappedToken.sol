// https://eips.ethereum.org/EIPS/eip-20
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract WrappedToken is ERC20Burnable {

    
    address bridge;
    
    constructor(address _bridge) ERC20('WrappedToken', 'WRT'){
        bridge = _bridge;
    }

    function mint(address to, uint amount) public
    {
        require(bridge == _msgSender(), 'NVT: Only bridge can mint new tokens');
        _mint(to, amount);
    }
}
