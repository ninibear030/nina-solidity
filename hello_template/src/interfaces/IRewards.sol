// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

library Cosmos {
    struct Coin {
        uint256 amount;
        string denom;
    }
}

interface IRewardsModule {
    function getCurrentRewards(
        address depositor, // account address
        address receiver // pool address
    ) external view returns (Cosmos.Coin[] memory);

    function withdrawAllDepositorRewards(
        address receiver
    ) external returns (Cosmos.Coin[] memory);
}
