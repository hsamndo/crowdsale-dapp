// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

import "../SimpleCrowdsale.sol";

abstract contract FixedPricingCrowdsale is SimpleCrowdsale {
    constructor(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _weiTokenPrice,
        uint256 _etherInvestmentObjective,
    )
        payable
        SimpleCrowdsale(
            _startTime,
            _endTime,
            _weiTokenPrice,
            _etherInvestmentObjective
        )
    {}

    function calculateNumberOfTokens(uint256 investment)
        internal
        override
        returns (uint256)
    {
        return investment / weiTokenPrice;
    }
}
