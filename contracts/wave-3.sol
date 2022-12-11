// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Wave3 {
    struct TopWaver {
        address addr;
        uint256 wavesCount;
    }

    struct WaverData {
        uint256 wavesCount;
        uint256 lastWaveTimestamp;
    }

    struct Wave {
        address waverAddr;
        uint256 timestamp;
    }

    uint256 totalWavesCount;
    Wave[] waves;
    mapping(address => WaverData) wavers;
    TopWaver[10] topWavers;

    constructor() {
        console.log("Wave3 Contract");
    }

    function wave() public {
        require(
            wavers[msg.sender].lastWaveTimestamp + 24 hours < block.timestamp,
            "You already waved at me in the last 24 hours. Please retry later !"
        );

        waves.push(Wave(msg.sender, block.timestamp));
        totalWavesCount += 1;
        wavers[msg.sender].wavesCount += 1;
        wavers[msg.sender].lastWaveTimestamp = block.timestamp;

        updateTopWavers(msg.sender, wavers[msg.sender].wavesCount);
    }

    function updateTopWavers(address addr, uint256 senderWavesCount) private {
        uint256 topIndex = 0;
        bool alreadyFound = false;
        uint256 alreadyFoundIndex = 0;

        for (; topIndex < topWavers.length; topIndex++) {
            if (senderWavesCount > topWavers[topIndex].wavesCount) {
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
        }

        topWavers[topIndex].addr = addr;
        topWavers[topIndex].wavesCount = senderWavesCount;
    }

    function getWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getSenderWavesCount() public view returns (uint256) {
        return wavers[msg.sender].wavesCount;
    }

    function getTotalWavesCount() public view returns (uint256) {
        return totalWavesCount;
    }

    function getTopWavers()
        public
        view
        returns (address[] memory, uint256[] memory)
    {
        address[] memory topWaversAddrs = new address[](topWavers.length);
        uint256[] memory topWaversWaves = new uint256[](topWavers.length);

        for (uint256 i = 0; i < topWavers.length; i++) {
            TopWaver storage topWaver = topWavers[i];

            topWaversAddrs[i] = topWaver.addr;
            topWaversWaves[i] = topWaver.wavesCount;
        }

        return (topWaversAddrs, topWaversWaves);
    }
}
