// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenGamingToken is ERC20, Ownable {
    string private constant _tokenName = "Degen";
    string private constant _tokenSymbol = "DGN";

    struct Item {
        string name;
        uint256 price;
    }

    Item[] public items;

    mapping(address => Item[]) public redeemedItems;

    constructor(address initialOwner) ERC20(_tokenName, _tokenSymbol) Ownable(initialOwner) {
        items.push(Item("Concealer", 100 * 10 ** decimals()));
        items.push(Item("Foundation", 150 * 10 ** decimals()));
        items.push(Item("Lipstick", 50 * 10 ** decimals()));
        items.push(Item("Eyeshadow Palette", 200 * 10 ** decimals()));
        items.push(Item("Mascara", 70 * 10 ** decimals()));
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function redeem(uint256 itemId) public {
        require(itemId < items.length, "Invalid item ID");
        Item memory item = items[itemId];
        _burn(msg.sender, item.price);
        redeemedItems[msg.sender].push(item);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function getItemsCount() public view returns (uint256) {
        return items.length;
    }

    function getItem(uint256 itemId) public view returns (string memory itemName, uint256 price) {
        require(itemId < items.length, "Invalid item ID");
        Item storage item = items[itemId];
        return (item.name, item.price);
    }

    function getRedeemedItems(address user) public view returns (Item[] memory) {
        return redeemedItems[user];
    }

    // Explicitly added transfer function
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
}
