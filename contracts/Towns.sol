// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Towns {
    struct Town {
        string townName;
        string townAddress;
        uint64 time; // 记录时间戳，0表示无数据
    }

    mapping(address => Town) public indexs;
    address[] public townOwners;

    event TownAddedOrUpdated(string name, string townAddress, uint64 time, address owner);

    function townRegistry(string calldata _name, string calldata _townAddress) external {
        Town storage town = indexs[msg.sender];

        // 如果之前没有注册（time==0），则push地址
        if (town.time == 0) {
            townOwners.push(msg.sender);
        }

        town.townName = _name;
        town.townAddress = _townAddress;
        town.time = uint64(block.timestamp);

        emit TownAddedOrUpdated(_name, _townAddress, town.time, msg.sender);
    }

    function townOffline(string calldata _name, string calldata _townAddress) external {

    }

    function townHearBeat() external {
        Town storage town = indexs[msg.sender];

        // 如果之前没有注册（time==0），则push地址
        if (town.time == 0) {
            return;
        }

        town.time = uint64(block.timestamp);
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

    function getAllTowns() external view returns (
        string[] memory names,
        string[] memory addresses_
    ) {
        uint256 len = townOwners.length;
        names = new string[](len);
        addresses_ = new string[](len);

        for (uint256 i = 0; i < len; i++) {
            address owner = townOwners[i];
            Town storage town = indexs[owner];
            names[i] = town.townName;
            addresses_[i] = town.townAddress;
        }

        return (names, addresses_);
    }

    function getTownsCount() external view returns (uint256) {
        return townOwners.length;
    }
}
