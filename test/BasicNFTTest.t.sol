//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";

contract TestBasicNFTContract is Test {
    BasicNFT public basicNFT;
    DeployBasicNFT public deployer;

    address public USER = makeAddr("User");
    string public constant FREE_PALESTINE =
        "ipfs://QmR3cCmDtawFFHk1Jc2ZD7Z9MCe92cK1kjE1GsbtmgTCEU";

    function setUp() public {
        deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNFT.name();
        // array of bytes.. the == operator only works on primitive solidity types
        // for (loop through the array) and compare the elements
        // or we could hash the arrays and compare
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNFT.mintNft(FREE_PALESTINE);
        assert(basicNFT.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(FREE_PALESTINE)) ==
                keccak256(abi.encodePacked(basicNFT.tokenURI(0)))
        );
    }
}
