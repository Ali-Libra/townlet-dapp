// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TownList {
    struct Town {
        string townName;
        string townAddress;
        uint64 time; // 记录时间戳，0表示无数据
    }

    event DebugLog(string message);

    mapping(address => Town) public indexs;
    address[] public townOwners;

    function townRegistry(string calldata _name, string calldata _townAddress) external {
        Town storage town = indexs[msg.sender];

        // 如果之前没有注册（time==0），则push地址
        if (town.time == 0) {
            townOwners.push(msg.sender);
        }

        town.townName = _name;
        town.townAddress = _townAddress;
        town.time = uint64(block.timestamp);
    }

    function townHearBeat() external {
        Town storage town = indexs[msg.sender];

        // 如果之前没有注册（time==0），则push地址
        if (town.time == 0) {
            return;
        }

        town.time = uint64(block.timestamp);
    }

    function townOffline() external {
        Town storage town = indexs[msg.sender];

        // 如果之前没有注册（time==0），则push地址
        if (town.time == 0) {
            return;
        }

        town.time = 1;
    }

    function getMyTown() external view returns (string memory, string memory, uint64) {
        Town storage town = indexs[msg.sender];
        require(town.time != 0, "You have not registered a town");
        return (town.townName, town.townAddress, town.time);
    }

    function getTownByOwner(address owner) external view returns (string memory, string memory, uint64) {
        Town storage town = indexs[owner];
        require(town.time != 0, "Owner has not registered a town");
        return (town.townName, town.townAddress, town.time);
    }

    function getAllTowns() external view returns (string[] memory names_, string[] memory addresses_) {
        uint256 len = townOwners.length;
        names_ = new string[](len);
        addresses_ = new string[](len);

        for (uint256 i = 0; i < len; i++) {
            address owner = townOwners[i];
            Town memory town = indexs[owner];
            names_[i] = town.townName;
            addresses_[i] = town.townAddress;
        }

        return (names_, addresses_);
    }

    function getTownsCount() external view returns (uint256) {
        return townOwners.length;
    }
}
