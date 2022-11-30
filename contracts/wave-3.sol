// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Wave3 {
    struct TopWaver {
        address addr;
        uint256 waves;
    }

    struct Wave {
        uint256 wavesNumber;
        uint256 lastWaveTimestamp;
    }

    uint256 totalWaves;
    mapping(address => Wave) wavers;
    TopWaver[10] topWavers;

    constructor() {
        console.log("Wave3 Contract");
    }

    function wave() public {
        require(
            wavers[msg.sender].lastWaveTimestamp < block.timestamp - 86400,
            "You already waved in the last 24 hours."
        );

        totalWaves += 1;
        wavers[msg.sender].wavesNumber += 1;
        wavers[msg.sender].lastWaveTimestamp = block.timestamp;

        console.log("%s has waved ! (%d)", msg.sender, block.timestamp);
        updateTopWavers(msg.sender, wavers[msg.sender].wavesNumber);
    }

    function updateTopWavers(address addr, uint256 senderWavesNumber) private {
        uint256 topIndex = 0;
        bool alreadyFound = false;
        uint256 alreadyFoundIndex = 0;

        for (; topIndex < topWavers.length; topIndex++) {
            if (senderWavesNumber > topWavers[topIndex].waves) {
                break;
            }
        }

        if (topIndex >= topWavers.length) {
            return;
        }

        for (uint256 k = 0; k < topWavers.length; k++) {
            if (topWavers[k].addr == addr) {
                alreadyFound = true;
                alreadyFoundIndex = k;
            }
        }

        for (
            uint256 i = alreadyFound ? alreadyFoundIndex : topWavers.length - 1;
            i > topIndex;
            i--
        ) {
            topWavers[i].addr = topWavers[i - 1].addr;
            topWavers[i].waves = topWavers[i - 1].waves;
        }

        topWavers[topIndex].addr = addr;
        topWavers[topIndex].waves = senderWavesNumber;
    }

    function getSenderWaves() public view returns (uint256) {
        console.log("Sender waved %d times !", wavers[msg.sender].wavesNumber);
        return wavers[msg.sender].wavesNumber;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves !", totalWaves);
        return totalWaves;
    }

    function getTopWavers()
        public
        view
        returns (address[] memory, uint256[] memory)
    {
        console.log("Top 10 wavers :");

        for (uint256 i = 0; i < topWavers.length; i++) {
            console.log(topWavers[i].addr, "-", topWavers[i].waves, "waves");
        }

        address[] memory topWaversAddrs = new address[](topWavers.length);
        uint256[] memory topWaversWaves = new uint256[](topWavers.length);

        for (uint256 i = 0; i < topWavers.length; i++) {
            TopWaver storage topWaver = topWavers[i];

            topWaversAddrs[i] = topWaver.addr;
            topWaversWaves[i] = topWaver.waves;
        }

        return (topWaversAddrs, topWaversWaves);
    }
}
