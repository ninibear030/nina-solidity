// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ILendRewardsAggregator {
    function getAllRewards(address _owner) external view returns (uint256);

    function claimAllRewards(address _receiver) external;
}
