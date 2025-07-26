// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "./Towns.sol";

contract TownMaps {
    struct MapTile {
        address builder;
        uint256 terrain;
    }
    struct TownMap {
        mapping(uint256 => MapTile) mapTiles; // 小镇的地图格子
        uint256[] tiles;
    }
    
    Towns public contractTowns;
    mapping(uint256 => TownMap) private townMaps;
    constructor(address _contractTowns) { 
        contractTowns = Towns(_contractTowns); 
    }

    event MapTileUpdated(uint256 townId, uint256 index, uint256 terrain, bool isOccupied, uint256 resources);

    // 设置某个小镇地图格子的属性
    function editTownTile(
        uint256 _townId,
        uint256[] calldata _index,
        uint256[] calldata _terrain
    ) external {
        require(_index.length == _terrain.length,"Index and terrain length must be equal");
        require(_townId <= contractTowns.getTownCount(),"town have not been created");

        TownMap storage town = townMaps[_townId];
        for (uint256 i = 0; i < _index.length; i++) {
            uint256 index = _index[i];
            MapTile storage tile = town.mapTiles[index];
            if (tile.terrain == 0) { // 无地形，任何人可放置
                tile.terrain = _terrain[i];
                tile.builder = msg.sender;
                town.tiles.push(index);
            } else { //已有地形，只有拥有者可放置
                require(tile.builder == msg.sender, "Only the builder can modify the terrain");
                tile.terrain = _terrain[i];
            }
        }

        // emit MapTileUpdated(townId, index, terrain, isOccupied, resources);
    }

    function getTownTiles(uint256 _townId) external view returns (uint256[] memory tiles, uint256[] memory terrains) {
        require(_townId <= contractTowns.getTownCount(),"Town have not been created");
        TownMap storage town = townMaps[_townId];

        tiles = new uint256[](town.tiles.length);
        terrains = new uint256[](town.tiles.length);

        for (uint256 i = 0; i < town.tiles.length; i++) {
            uint256 tileIndex = town.tiles[i];
            tiles[i] = tileIndex;
            terrains[i] = town.mapTiles[tileIndex].terrain;
        }
        return (tiles, terrains);
    }

    // 获取某个小镇某个地图格子的属性
    function getMapTile(uint256 _townId, uint256 index) external view returns (uint256) {
        require(_townId <= contractTowns.getTownCount(),"Town have not been created");

        MapTile memory tile = townMaps[_townId].mapTiles[index];
        return tile.terrain;
    }
}
