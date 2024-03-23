// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    error InvalidCampaign();
    error InvalidContributionAmount();

    event ContributionMade(
        address indexed contributor,
        uint256 indexed campaignIndex,
        uint256 amount,
        uint256 newBalance
    );

    event CampaignCreated(
        address creator,
        string name,
        string description,
        uint256 campaignGoal,
        uint256 deadline,
        uint256 minAmount,
        uint256 balance
    );

    event AllCampaigns(
        address creator,
        string name,
        string description,
        uint256 campaignGoal,
        uint256 deadline,
        uint256 minAmount,
        uint256 balance
    );

    enum CampaingPurpose {
        Personal,
        ThirdParty,
        Charitable
    }

    struct Campaign {
        address creator;
        string name;
        CampaingPurpose campaingPurpose;
        string description;
        uint256 campaignGoal;
        uint256 deadline;
        uint256 currentBalance;
        uint256 minAmount;
    }

    Campaign[] campaigns;

    function createCampaign(
        address _creator,
        string calldata _name,
        string calldata _description,
        uint256 _campaignGoal,
        uint256 _deadline,
        uint256 _currentBalance,
        uint256 _minAmount
    ) external {
        Campaign memory campaign = Campaign({
            creator: _creator,
            name: _name,
            description: _description,
            campaignGoal: _campaignGoal,
            deadline: _deadline,
            campaingPurpose: CampaingPurpose.Personal,
            currentBalance: _currentBalance,
            minAmount: _minAmount
        });

        emit CampaignCreated(
            _creator,
            _name,
            _description,
            _campaignGoal,
            _deadline,
            _minAmount,
            _currentBalance
        );

        campaigns.push(campaign);
    }

    function getAllCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](campaigns.length);
        for (uint256 i = 0; i < campaigns.length; i++) {
            allCampaigns[i] = campaigns[i];
        }

        return allCampaigns;
    }

    function getCurrentBalance(uint256 _campaignId)
        public
        view
        returns (uint256, uint, uint)
    {
        Campaign memory campaign = campaigns[_campaignId];
        uint amountLeft = campaign.campaignGoal - campaign.currentBalance;

        return (campaign.campaignGoal, campaign.currentBalance, amountLeft);
    }

    function contribute(uint256 _campaignIndex) external payable {
        if (_campaignIndex > campaigns.length) revert InvalidCampaign();
        Campaign storage campaign = campaigns[_campaignIndex];

        if (msg.value == 0 || msg.value < campaign.minAmount)
            revert InvalidContributionAmount();

        uint256 amount = msg.value;
        campaign.currentBalance += amount;

        emit ContributionMade(
            msg.sender,
            _campaignIndex,
            amount,
            campaign.currentBalance
        );
    }
}
