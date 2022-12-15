// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Wave3 {
    struct TopWaver {
        address addr;
        uint256 wavesCount;
        uint256 lastWaveTimestamp;
    }

    struct WaverData {
        uint256 wavesCount;
        uint256 lastWaveTimestamp;
    }

    struct Wave {
        address waverAddr;
        uint256 timestamp;
    }

    event NewWave(address indexed waverAddr, uint256 timestamp);

    Wave[] waves;
    mapping(address => WaverData) wavers;
    TopWaver[3] topWavers;

    constructor() {
        console.log("Wave3 Contract");
    }

    function wave() public {
        // require(
        //     wavers[msg.sender].lastWaveTimestamp + 24 hours < block.timestamp,
        //     "You already waved at me in the last 24 hours. Please retry later !"
        // );

        waves.push(Wave(msg.sender, block.timestamp));

        wavers[msg.sender].wavesCount += 1;
        wavers[msg.sender].lastWaveTimestamp = block.timestamp;

        updateTopWavers(
            msg.sender,
            wavers[msg.sender].wavesCount,
            wavers[msg.sender].lastWaveTimestamp
        );

        emit NewWave(msg.sender, block.timestamp);
    }

    function updateTopWavers(
        address addr,
        uint256 wavesCount,
        uint256 lastWaveTimestamp
    ) private {
        uint256 topIndex = 0;
        bool alreadyFound = false;
        uint256 alreadyFoundIndex = 0;

        for (; topIndex < topWavers.length; topIndex++) {
            if (wavesCount > topWavers[topIndex].wavesCount) {
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
            topWavers[i].wavesCount = topWavers[i - 1].wavesCount;
            topWavers[i].lastWaveTimestamp = topWavers[i - 1].lastWaveTimestamp;
        }

        topWavers[topIndex].addr = addr;
        topWavers[topIndex].wavesCount = wavesCount;
        topWavers[topIndex].lastWaveTimestamp = lastWaveTimestamp;
    }

    function getWaves(
        uint256 offset,
        uint256 limit
    ) public view returns (Wave[] memory) {
        if (limit > waves.length - offset) {
            limit = waves.length - offset;
        }

        // Reverse the wave array, to make it descending

        Wave[] memory reversedWaves = new Wave[](waves.length);
        uint256 j = 0;

        for (uint256 i = waves.length; i >= 1; i--) {
            reversedWaves[j] = waves[i - 1];
            j++;
        }

        // Get array of the desired range (with offset and limit)

        Wave[] memory paginatedWaves = new Wave[](limit);

        for (uint256 i = 0; i < limit; i++) {
            paginatedWaves[i] = reversedWaves[offset + i];
        }

        return paginatedWaves;
    }

    function getSenderWavesCount() public view returns (uint256) {
        return wavers[msg.sender].wavesCount;
    }

    function getTotalWavesCount() public view returns (uint256) {
        return waves.length;
    }

    function getTopWavers() public view returns (TopWaver[3] memory) {
        return topWavers;
    }
}
