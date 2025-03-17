// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract SecondHandItemTracker {
    struct Item {
        uint256 id;
        string name;
        address[] owners;
    }

    mapping(uint256 => Item) private items;
    uint256 private itemCount;

    event ItemRegistered(uint256 itemId, string name, address owner);
    event OwnershipTransferred(uint256 itemId, address previousOwner, address newOwner);

    function registerItem(string memory name) public {
        itemCount++;
        items[itemCount] = Item(itemCount, name, new address[](1));
        items[itemCount].owners[0] = msg.sender;
        emit ItemRegistered(itemCount, name, msg.sender);
    }

    function transferOwnership(uint256 itemId, address newOwner) public {
        require(itemId > 0 && itemId <= itemCount, "Item does not exist");
        require(items[itemId].owners[items[itemId].owners.length - 1] == msg.sender, "Only the current owner can transfer");
        
        items[itemId].owners.push(newOwner);
        emit OwnershipTransferred(itemId, msg.sender, newOwner);
    }

    function getItemHistory(uint256 itemId) public view returns (string memory, address[] memory) {
        require(itemId > 0 && itemId <= itemCount, "Item does not exist");
        return (items[itemId].name, items[itemId].owners);
    }
}
