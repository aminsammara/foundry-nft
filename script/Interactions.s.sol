//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNFT} from "../src/BasicNFT.sol";

contract MintBasicNFT is Script {
    string public constant FREE_PALESTINE =
        "https://ipfs.io/ipfs/QmNkTLgBWRWwACbNDsC7vM8DHnxbzfuw9vef8B9EuK5c8q?filename=FREE_PALESTINE.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNFT",
            block.chainid
        );
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNFT(contractAddress).mintNft(FREE_PALESTINE);
        vm.stopBroadcast();
    }
}
