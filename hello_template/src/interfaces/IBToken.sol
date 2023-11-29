// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IBToken {
    function pendingBGT(address owner) external view returns (uint256);

    function claimBGT(uint256 amount, address recipient) external;
}
