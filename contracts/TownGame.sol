// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "./BagItems.sol";

contract TownGame {
    BagItems public bagItems;  // bag

    constructor() {
        bagItems = BagItems(msg.sender);
    }
}