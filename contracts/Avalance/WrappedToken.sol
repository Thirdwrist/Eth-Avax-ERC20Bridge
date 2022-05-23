// https://eips.ethereum.org/EIPS/eip-20
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract WrappedToken is ERC20Burnable {

    
    address avaxGateway;
    
    constructor(address _avaxGateway) ERC20('WrappedToken', 'WRPT'){
        avaxGateway = _avaxGateway;
    }

    function mint(address to, uint amount) public
    {
        require(avaxGateway == _msgSender(), 'WRPT: Only AvaxGateway can mint new tokens');
        _mint(to, amount);
    }
}
