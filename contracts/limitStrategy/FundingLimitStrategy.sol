// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

abstract contract FundingLimitStrategy {
    function isFullInvestmentWithinLimit(
        uint256 _investment,
        uint256 _fullInvestmentReceived
    ) virtual public view returns (bool);
}
