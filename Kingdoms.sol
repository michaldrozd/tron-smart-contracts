// Copyright (C) 2021 Michal Drozd
// All Rights Reserved

pragma solidity ^0.4.24;

contract Kingdoms {
    // Struct to hold the information of a Kingdom
    struct Kingdom {
        address owner;
        uint army;
        uint gold;
        uint resources;
        mapping(string => uint) structures;
    }

    // Mapping to hold all the Kingdoms
    mapping(address => Kingdom) public kingdoms;

    // Event to be emitted on attack
    event Attack(address attacker, address defender, bool success);
    //Event to be emitted on structure building
    event Build(address owner, string structureName);

    // Function to create a new Kingdom
    function createKingdom(uint initialArmy, uint initialGold, uint initialResources) public {
        require(kingdoms[msg.sender].owner == address(0));
        kingdoms[msg.sender].owner = msg.sender;
        kingdoms[msg.sender].army = initialArmy;
        kingdoms[msg.sender].gold = initialGold;
        kingdoms[msg.sender].resources = initialResources;
    }

    // Function to attack another Kingdom
    function attack(address _defender) public {
        require(kingdoms[msg.sender].army > 0);
        require(kingdoms[_defender].owner != address(0));
        //calculate the success of the attack
        bool success = calculateAttack(kingdoms[msg.sender].army, kingdoms[_defender].army);
        if (success) {
            kingdoms[_defender].army = kingdoms[_defender].army / 2;
            kingdoms[msg.sender].gold += kingdoms[_defender].gold;
            kingdoms[msg.sender].resources += kingdoms[_defender].resources;
        } else {
            kingdoms[msg.sender].army = kingdoms[msg.sender].army / 2;
        }
        emit Attack(msg.sender, _defender, success);
    }
    // Function to build structures in a Kingdom
    function buildStructure(string _structureName) public {
        require(kingdoms[msg.sender].gold >= getStructureCost(_structureName));
        require(getStructureLevel(msg.sender, _structureName) == 0);
        kingdoms[msg.sender].gold -= getStructureCost(_structureName);
        kingdoms[msg.sender].structures[_structureName] = 1;
        emit Build(msg.sender, _structureName);
    }

    // Function to upgrade a structure in a Kingdom
    function upgradeStructure(string _structureName) public {
        require(kingdoms[msg.sender].gold >= getStructureUpgradeCost(_structureName));
        uint currentLevel = getStructureLevel(msg.sender, _structureName);
        require(currentLevel != 0);
        require(currentLevel < maxStructureLevel);
        kingdoms[msg.sender].gold -= getStructureUpgradeCost(_structureName);
        kingdoms[msg.sender].structures[_structureName]++;
    }

    // Function to get the current level of a structure in a Kingdom
    function getStructureLevel(address _owner, string _structureName) public view returns (uint) {
        return kingdoms[_owner].structures[_structureName];
    }

    // Function to get the cost of building a structure
    function getStructureCost(string _structureName) public view returns (uint) {
        if (_structureName == "wall") return 1000;
        if (_structureName == "tower") return 5000;
        if (_structureName == "barracks") return 10000;
    }

    // Function to get the cost of upgrading a structure
    function getStructureUpgradeCost(string _structureName) public view returns (uint) {
        if (_structureName == "wall") return 500;
        if (_structureName == "tower") return 2500;
        if (_structureName == "barracks") return 5000;
    }

    // Function to calculate the success of the attack
    function calculateAttack(uint attackerArmy, uint defenderArmy) private view returns (bool) {
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 2;
        if (random == 1 && attackerArmy > defenderArmy) return true;
        else return false;
    }
}