// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ILendRewardsAggregator} from "./interfaces/ILendRewardsAggregator.sol";
import {IBToken} from "./interfaces/IBToken.sol";
import {IRewardsModule, Cosmos} from "./interfaces/IRewards.sol";

import {Script, console2} from "forge-std/Script.sol";

contract Contract is Script {
    ILendRewardsAggregator lendRewardsAggregator;
    IBToken perpsRewarder;
    IRewardsModule rewardsModule;
    address AbgtRewarder;
    address AlendRewardsAggregator;
    address AperpsRewarder;

    constructor(
        address _bgtRewarder,
        address _lendRewardsAggregator,
        address _perpsRewarder
    ) {
        rewardsModule = IRewardsModule(_bgtRewarder);
        AbgtRewarder = _bgtRewarder;
        lendRewardsAggregator = ILendRewardsAggregator(_lendRewardsAggregator);
        AlendRewardsAggregator = _lendRewardsAggregator;
        perpsRewarder = IBToken(_perpsRewarder);
        AperpsRewarder = _perpsRewarder;
    }

    function getAllRewards(
        address _owner,
        address[] memory dexPoolAddresses
    )
        external
        returns (
            uint256 dexPendingRewards,
            uint256 lendPendingRewards,
            uint256 perpsPendingRewards
        )
    {
        uint256 totalDexPendingRewards = 0;
        for (uint256 i = 0; i < dexPoolAddresses.length; i++) {
            (bool success, bytes memory data) = AbgtRewarder.delegatecall(
                abi.encodeWithSelector(
                    rewardsModule.getCurrentRewards.selector,
                    _owner,
                    dexPoolAddresses[i]
                )
            );
            if (success && data.length > 0) {
                // Decode the data to get rewards
                Cosmos.Coin[] memory rewards = abi.decode(
                    data,
                    (Cosmos.Coin[])
                );
                if (rewards.length > 0) {
                    totalDexPendingRewards += rewards[0].amount;
                }
            }
        }

        uint256 totalLendPendingRewards = lendRewardsAggregator.getAllRewards(
            _owner
        );
        uint256 totalPerpsPendingRewards = perpsRewarder.pendingBGT(_owner);
        return (
            totalDexPendingRewards,
            totalLendPendingRewards,
            totalPerpsPendingRewards
        );
    }

    function test() external view {
        console2.log("testtest");
    }

    function claimAllRewards(
        address _receiver,
        address[] memory dexPoolAddresses
    ) external payable {
        // for (uint256 i = 0; i < dexPoolAddresses.length; i++) {
        //     Cosmos.Coin[] memory rewards = rewardsModule.getCurrentRewards(
        //         _receiver,
        //         dexPoolAddresses[i]
        //     );
        //     if (rewards.length > 0) {
        //         Cosmos.Coin memory coin = rewards[0];
        //         if (coin.amount > 0) {
        //             rewardsModule.withdrawAllDepositorRewards(
        //                 dexPoolAddresses[i]
        //             );
        //         }
        //     }
        // }
        console2.logString("FFFFF");

        for (uint256 i = 0; i < dexPoolAddresses.length; i++) {
            (bool success, bytes memory data) = AbgtRewarder.delegatecall(
                abi.encodeWithSelector(
                    rewardsModule.getCurrentRewards.selector,
                    _receiver,
                    dexPoolAddresses[i]
                )
            );
            console.log("%s", "FFFFF");
            console.log("%s", "FFFFF");

            if (success && data.length > 0) {
                Cosmos.Coin[] memory rewards = abi.decode(
                    data,
                    (Cosmos.Coin[])
                );
                console.log("%s", "FFFFF");
                console.log("%s", "FFFFF");
                console.log("%s", "FFFFF");

                if (rewards.length > 0 && rewards[0].amount > 0) {
                    console.log("%s", "FFFFF");
                    console.log("%s", "FFFFF");
                    console.log("%s", "FFFFF");
                    console.log("%s", "FFFFF");
                    (bool success2, bytes memory returnData) = AbgtRewarder
                        .delegatecall(
                            abi.encodeWithSelector(
                                rewardsModule
                                    .withdrawAllDepositorRewards
                                    .selector,
                                dexPoolAddresses[i]
                            )
                        );
                    if (success2 == false) {
                        if (returnData.length > 0) {
                            assembly {
                                let returndata_size := mload(returnData)
                                revert(add(32, returnData), returndata_size)
                            }
                        } else {
                            revert("Function call reverted");
                        }
                    }
                }
            }
        }

        // uint256 lendAvailableBalance = lendRewardsAggregator.getAllRewards(_receiver);
        // if (lendAvailableBalance > 0) {
        //     (bool success, bytes memory data) = AlendRewardsAggregator
        //         .delegatecall(
        //             abi.encodeWithSelector(
        //                 lendRewardsAggregator.claimAllRewards.selector,
        //                 _receiver
        //             )
        //         );
        //    if (success == false) {
        //         if (data.length > 0) {
        //             assembly {
        //                 let returndata_size := mload(data)
        //                 revert(add(32, data), returndata_size)
        //             }
        //         } else {
        //             revert("Function call reverted");
        //         }
        //     }
        // }

        // uint256 perpsAvailableBalance = perpsRewarder.pendingBGT(_receiver);
        // if (perpsAvailableBalance > 0)
        //     perpsRewarder.claimBGT(perpsAvailableBalance, _receiver);
    }
}
