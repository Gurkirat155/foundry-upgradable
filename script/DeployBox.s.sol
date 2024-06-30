// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {console} from "forge-std/console.sol";

contract DeployBox is Script {
    function run() external returns (address) {
        address proxy = deployV1();
        return (proxy);
    }

    function deployV1() public returns (address) {
        vm.startBroadcast();
        BoxV1 box = new BoxV1();
        // console.log("BoxV1 deployed at: ", address(box));
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), "");
        console.log("Proxy deployed for V1 at: ", address(proxy));
        vm.stopBroadcast();
        return address(proxy);
    }
}
