// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Wave3 {
    uint256 totalWaves;

    constructor() {
        console.log("Wave3 Contract");
    }

    function wave() public {
        totalWaves += 1;
        console.log("%s has waved !", msg.sender);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves !", totalWaves);
        return totalWaves;
    }
}
