// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

import "./limitStrategy/UnlimitedFundingStrategy.sol";
import "./pricingStrategy/FixedPricingCrowdsale.sol";

contract UnlimitedFixedPricingCrowdsale is FixedPricingCrowdsale {
    constructor(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _weiTokenPrice,
        uint256 _etherInvestmentObjective
    )
        payable
        FixedPricingCrowdsale(
            _startTime,
            _endTime,
            _weiTokenPrice,
            _etherInvestmentObjective
        )
    {}

    function createFundingLimitStrategy()
        internal
        returns (FundingLimitStrategy)
    {
        return new UnlimitedFundingStrategy();
    }
}
