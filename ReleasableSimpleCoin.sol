pragma solidity ^0.4.18;

import "./SimpleCoin.sol";
import "./Pausable.sol";
import "./Destructible.sol";

contract ReleasableSimpleCoin is SimpleCoin, Pausable, Destructible {
    bool public released = false;
    
    modifier isReleased() {
        if (!released) revert();
        _;
    }
    
    constructor (uint256 _initialSupply) 
        SimpleCoin(_initialSupply) public {}
    
    function release() 
        onlyOwner public {
        released = true;
    }
    
    function transfer(address _to, uint256 _amount) 
        isReleased public {
        super.transfer(_to, _amount);
    }
    
    function transferFrom(address _from, address _to, uint256 _amount)
        isReleased public returns (bool) {
            super.transferFrom(_from, _to, _amount);
        }
}