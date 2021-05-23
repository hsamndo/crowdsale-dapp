// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

import "../utils/Ownable.sol";

contract SimpleCoin is Ownable {
    mapping(address => uint256) public coinBalance;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public frozenAccount;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event FrozenAccount(address target, bool frozen);

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        mint(owner, _initialSupply);
    }

    function mint(address _receipient, uint256 _mintedAmount) public onlyOwner {
        coinBalance[_receipient] += _mintedAmount;

        emit Transfer(owner, _receipient, _mintedAmount);
    }

    function transfer(address _to, uint256 _amount) public {
        require(coinBalance[msg.sender] > _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]);
        coinBalance[msg.sender] -= _amount;
        coinBalance[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    function authorize(address _authorizedAccount, uint256 _allowance)
        public
        returns (bool success)
    {
        allowance[msg.sender][_authorizedAccount] = _allowance;
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public returns (bool success) {
        require(coinBalance[_from] >= _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]);
        require(_amount <= allowance[_from][msg.sender]);

        coinBalance[_from] -= _amount;
        coinBalance[_to] += _amount;
        allowance[_from][msg.sender] -= _amount;

        emit Transfer(_from, _to, _amount);

        return true;
    }

    function freezeAccount(address _target, bool _freeze) public onlyOwner {
        frozenAccount[_target] = _freeze;

        emit FrozenAccount(_target, _freeze);
    }
}
