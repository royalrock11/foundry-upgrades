// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "lib/forge-std/src/Test.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {DeployBox} from "script/DeployBox.s.sol";
import {UpgradeBox} from "script/UpgradeBox.s.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("owner");

    address public proxy;

    function setup() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run();
    }

    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);
    }

    function testUpgrades() public {
        BoxV2 box2 = new BoxV2();

        upgrader.upgradeBox(proxy, address(box2));
        assertEq(expectedValue, BoxV2(proxy).version());

        BoxV2(proxy).setNumber(7);
        assertEq(7, BoxV2(proxy).getNumber());
    }
}
