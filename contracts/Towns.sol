// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Towns is ERC721URIStorage {
    // 小镇结构
    struct Town {
        string townName;
        string townAddress;
        uint64 time;
    }
    uint256 private townCount;
    mapping(uint256 => Town) private towns;

    // 事件
    event TownCreated(address indexed creator, uint256 townId);

    constructor() ERC721("TownNFT", "TOWN") {}

    function createTown(string calldata _name, string calldata _townAddress) external {
        uint256 townId = townCount;
        townCount++;
        // 创建小镇
        Town storage newTown = towns[townId];
        newTown.townName = _name;
        newTown.townAddress = _townAddress;
        newTown.time = uint64(block.timestamp);

        _safeMint(msg.sender, townId);
        // emit TownCreated(msg.sender, townId, _name, _townAddress, newTown.time);
    }

    function townUpdateName(uint256 _townId, string calldata _name) external {
        require(
            ownerOf(_townId) == msg.sender,
            "Only the town owner can update the town"
        );

        Town storage town = towns[_townId];
        town.townName = _name;
        town.time = uint64(block.timestamp);
    }

    function townUpdateAddress(uint256 _townId, string calldata _townAddress) external {
        require(
            ownerOf(_townId) == msg.sender,
            "Only the town owner can update the town"
        );

        Town storage town = towns[_townId];
        town.townAddress = _townAddress;
        town.time = uint64(block.timestamp);
    }

    function townHearBeat(uint256 _townId) external {
        require(
            ownerOf(_townId) == msg.sender,
            "Only the town owner can update the town"
        );

        Town storage town = towns[_townId];
        town.time = uint64(block.timestamp);
    }

    function getTownAddress(uint256 _townId) external view returns (string memory) {
        require(_townId < getTownCount(),"Town have not been created");
        Town memory town = towns[_townId];
        require(town.time != 0, "Town is not exist");
        return town.townAddress;
    }

    function getAllTowns() external view returns (string[] memory names_, string[] memory addresses_) {
        names_ = new string[](townCount);
        addresses_ = new string[](townCount);

        for (uint256 i = 0; i < townCount; i++) {
            names_[i] = towns[i].townName;
            addresses_[i] = towns[i].townAddress;
        }

        return (names_, addresses_);
    }

    function getTownCount() public view returns (uint256) {
        return townCount;
    }
}
