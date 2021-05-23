// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

import "./SimpleCoin.sol";
import "../utils/Pausable.sol";
import "../utils/Destructible.sol";

contract ReleasableSimpleCoin is SimpleCoin, Pausable, Destructible {
    bool public released = false;

    modifier isReleased() {
        if (!released) revert();
        _;
    }

    constructor(uint256 _initialSupply) SimpleCoin(_initialSupply) {}

    function release() public onlyOwner {
        released = true;
    }

    function transfer(address _to, uint256 _amount) override public isReleased {
        super.transfer(_to, _amount);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) override public isReleased returns (bool) {
        super.transferFrom(_from, _to, _amount);
    }
}
