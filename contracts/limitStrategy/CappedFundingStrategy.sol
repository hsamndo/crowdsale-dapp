// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

import "./FundingLimitStrategy.sol";

contract CappedFundingStrategy is FundingLimitStrategy {
    uint256 fundingCap;

    constructor(uint256 _fundingCap) {
        require(_fundingCap > 0);
        _fundingCap = fundingCap;
    }

    function isFullInvestmentWithinLimit(
        uint256 _investment,
        uint256 _fullInvestmentReceived
    ) override public view returns (bool check) {
        check = _fullInvestmentReceived + _investment <= fundingCap;
    }
}
