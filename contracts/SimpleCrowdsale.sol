// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

import "./utils/Ownable.sol";
import "./utils/Pausable.sol";
import "./utils/Destructible.sol";
import "./coin/ReleasableSimpleCoin.sol";
import "./limitStrategy/FundingLimitStrategy.sol";

abstract contract SimpleCrowdsale is Ownable, Pausable, Destructible {
    uint256 public startTime;
    uint256 public endTime;
    uint256 public weiTokenPrice;
    uint256 public weiInvestmentObjective;

    mapping(address => uint256) public investmentAmountOf;
    uint256 public investmentReceived;
    uint256 public investmentRefunded;

    bool public isFinalized;
    bool public isRefundingAllowed;

    ReleasableSimpleCoin public crowdsaleToken;
    FundingLimitStrategy internal fundingLimitStrategy;

    constructor(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _weiTokenPrice,
        uint256 _weiInvestmentObjective
    ) payable {
        require(_startTime >= block.timestamp);
        require(_endTime >= _startTime);
        require(_weiTokenPrice != 0);
        require(_weiInvestmentObjective != 0);

        startTime = _startTime;
        endTime = _endTime;
        weiTokenPrice = _weiTokenPrice * 1000000000000000000;
        weiInvestmentObjective = _weiInvestmentObjective * 1000000000000000000;

        crowdsaleToken = new ReleasableSimpleCoin(0);
        isFinalized = false;

        fundingLimitStrategy = createFundingLimitStrategy();
    }

    event LogInvestment(address indexed investor, uint256 value);
    event LogTokenAssigned(address indexed investor, uint256 numTokens);
    event Refund(address investor, uint256 value);

    function invest() public payable {
        require(isValidInvestment(msg.value));

        address investor = msg.sender;
        uint256 investment = msg.value;

        investmentAmountOf[investor] += investment;
        investmentReceived += investment;

        assigTokens(investor, investment);

        emit LogInvestment(investor, investment);
    }

    function createFundingLimitStrategy()
        internal
        virtual
        returns (FundingLimitStrategy);

    function isValidInvestment(uint256 _investment)
        internal
        view
        returns (bool)
    {
        bool nonZeroInvestment = _investment != 0;
        bool withinCrowdSalePeriod = true; /*now >= startTime &&  now <= endTime;*/

        return
            nonZeroInvestment &&
            withinCrowdSalePeriod &&
            fundingLimitStrategy.isFullInvestmentWithinLimit(
                _investment,
                investmentReceived
            );
    }

    function isFullInvestmentWithinLimit(uint256 _investment)
        internal
        view
        returns (bool)
    {
        return true;
    }

    function assigTokens(address _beneficiary, uint256 _investment) internal {
        uint256 _numberOfTokens = calculateNumberOfTokens(_investment);

        crowdsaleToken.mint(_beneficiary, _numberOfTokens);
    }

    function calculateNumberOfTokens(uint256 investment)
        virtual
        internal
        returns (uint256);

    function finalize() public onlyOwner {
        if (isFinalized) revert();

        bool isCrowdsaleComplete = true;
        bool investmentObjectiveMet =
            investmentReceived >= weiInvestmentObjective;

        if (isCrowdsaleComplete) {
            if (investmentObjectiveMet) crowdsaleToken.release();
            else isRefundingAllowed = true;
            isFinalized = true;
        }
    }

    function refund() public {
        if (!isRefundingAllowed) revert();

        address payable investor = payable(msg.sender);
        uint256 investment = investmentAmountOf[investor];
        if (investment == 0) revert();
        investmentAmountOf[investor] = 0;
        investmentRefunded += investment;
        emit Refund(msg.sender, investment);

        if (!investor.send(investment)) revert();
    }
}
