// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

import "./limitStrategy/UnlimitedFundingStrategy.sol";
import "./pricingStrategy/TranchePricingCrowdsale.sol";

contract UnlimitedTranchePricingCrowdsale is TranchePricingCrowdsale {
    constructor(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _etherInvestmentObjective
    )
        payable
        TranchePricingCrowdsale(_startTime, _endTime, _etherInvestmentObjective)
    {}

    function createFundingLimitStrategy()
        internal
        override
        returns (FundingLimitStrategy)
    {
        return new UnlimitedFundingStrategy();
    }
}
