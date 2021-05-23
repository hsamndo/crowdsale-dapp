// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

import "./FundingLimitStrategy.sol";

contract UnlimitedFundingStrategy is FundingLimitStrategy {
    function isFullInvestmentWithinLimit(
        uint256 _investment,
        uint256 _fullInvestmentReceived
    ) public pure override returns (bool check) {
        _investment = 0;
        _fullInvestmentReceived = 0;
        check = true;
    }
}
