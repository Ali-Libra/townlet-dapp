// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "./BagItems.sol";

contract TownGame {
    BagItems public bagItems;  // ERC1155 合约实例

    constructor() {
        bagItems = BagItems(msg.sender);  // 链接 ERC1155 合约
    }
}