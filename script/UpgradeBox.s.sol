// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract UpgradeBox is Script {
    //   function run() external returns(address) {
    //     address getRectDeploymentOfProxyContract = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
    //     // address getRectDeploymentOfProxyContract = DevOpsTools.get_most_recent_deployment("BoxV1", block.chainid);

    //     vm.startBroadcast();
    //     BoxV2 box2 = new BoxV2();
    //     // console.log("BoxV2 deployed for V2 at: ", address(box2));
    //     vm.stopBroadcast();
    //     address proxy = upgradeImplmentationAddress(address(box2), getRectDeploymentOfProxyContract);
    //     console.log("Proxy address for V2 at: ", proxy);
    //     return (proxy);
    //   }

    function upgradeImplmentationAddress(address newImplementation, address proxyAddress) public returns (address) {
        vm.startBroadcast();
        BoxV1 box1Proxy = BoxV1(proxyAddress);
        box1Proxy.upgradeToAndCall(newImplementation, "");
        vm.stopBroadcast();
        return address(box1Proxy);
    }
}
