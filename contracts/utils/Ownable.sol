// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
