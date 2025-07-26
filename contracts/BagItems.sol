// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BagItems is ERC1155, Ownable {
    // 游戏逻辑合约地址
    address public gameLogicContract;
    uint256 public constant MAX_ITEM_ID = 50;

    constructor() ERC1155("https://example.com/api/item/{id}.json") Ownable(msg.sender) {}

    modifier onlyGameLogic() {
        require(msg.sender == gameLogicContract, "Not authorized: Only game logic contract can mint");
        _;
    }

    function setGameLogicContract(address _gameLogicContract) external onlyOwner {
        require(_gameLogicContract != address(0), "Invalid address");
        gameLogicContract = _gameLogicContract;
    }

    function setUrl(string memory newurl) external onlyOwner {
        _setURI(newurl);
    }

    function mint(address to, uint256 id, uint256 amount) external onlyGameLogic {
        _mint(to, id, amount, "");
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts) external onlyGameLogic {
        _mintBatch(to, ids, amounts, "");
    }

    function burn(address from, uint256 id, uint256 amount) external onlyGameLogic {
        _burn(from, id, amount);
    }

    function gift(address to, uint256 id, uint256 amount) external {
        safeTransferFrom(msg.sender, to, id, amount, "");
    }

    function getItems() external view returns (uint256[] memory ids, uint256[] memory amounts) {
        uint256[] memory _ids = new uint256[](MAX_ITEM_ID);
        uint256[] memory _amounts = new uint256[](MAX_ITEM_ID);
        uint256 count = 0;

        for (uint256 i = 0; i < MAX_ITEM_ID; i++) {
            uint256 balance = balanceOf(msg.sender, i);
            if (balance > 0) {
                _ids[count] = i;
                _amounts[count] = balance;
                count++;
            }
        }
        
        uint256[] memory idsResult = new uint256[](count);
        uint256[] memory amountsResult = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            idsResult[i] = _ids[i];
            amountsResult[i] = _amounts[i];
        }

        return (idsResult, amountsResult);
    }

    function getItem(uint256 id) external view returns (uint256) { 
        return balanceOf(msg.sender, id);
    }
}
