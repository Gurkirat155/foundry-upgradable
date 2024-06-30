// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox deployBox;
    UpgradeBox upgradeBox;
    address public owner = makeAddr("Owner");

    // BoxV1 public boxV1;
    // BoxV2 public boxV2;
    address public proxy;

    function setUp() public {
        deployBox = new DeployBox();
        upgradeBox = new UpgradeBox();
        proxy = deployBox.run();
        // console.log("Deployed proxy address of Box V1 at: ", proxy);
    }

    modifier upgradingBox() {
        vm.startBroadcast();
        BoxV2 boxV2 = new BoxV2();
        vm.stopBroadcast();

        upgradeBox.upgradeImplmentationAddress(address(boxV2), proxy);
        _;
    }

    function testProxyStartsWithV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);
        console.log("BoxV2 shouldn't be able to call from proxy address as it is not deployed yet");
    }

    function testSetNumber() public upgradingBox {
        uint256 setVal = 5;

        assertEq(BoxV1(proxy).version(), 2);

        BoxV2(proxy).setNumber(setVal);

        uint256 getValFromV1 = BoxV1(proxy).getNumber();
        uint256 getValFromV2 = BoxV2(proxy).getNumber();
        // console.log("Value set in BoxV1: ", getValFromV1);
        // console.log("Value set in BoxV2: ", getValFromV2);
        assertEq(getValFromV1, setVal);
        assertEq(getValFromV2, setVal);
        assertEq(getValFromV1, getValFromV2);
    }

    function testUpgrades() public {
        uint256 version1 = 1;
        uint256 version2 = 2;

        vm.startBroadcast();
        BoxV2 boxV2 = new BoxV2();
        vm.stopBroadcast();

        uint256 versionBeforeupgrade = BoxV1(proxy).version();
        console.log("Version of Box before upgrade: ", versionBeforeupgrade);
        assertEq(versionBeforeupgrade, version1);

        upgradeBox.upgradeImplmentationAddress(address(boxV2), proxy);

        uint256 versionAfterUpgrade = BoxV1(proxy).version();
        console.log("Version of Box after upgrade: ", versionAfterUpgrade);
        assertEq(versionAfterUpgrade, version2);
    }
}
