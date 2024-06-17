//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract InteractionsMood is Script {
    MoodNFT public moodNFT;
    address public USER = makeAddr("USER");

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "MoodNFT",
            block.chainid
        );
        // mintNftOnContract(mostRecentlyDeployed);
        changeNftMood(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNFT(contractAddress).mintNft();
        vm.stopBroadcast();
    }

    function changeNftMood(address contractAddress) public {
        vm.startBroadcast();
        MoodNFT(contractAddress).changeMood(0, 2);
        vm.stopBroadcast();
    }
}
