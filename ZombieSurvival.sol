// Copyright (C) 2021 Michal Drozd
// All Rights Reserved

pragma solidity ^0.4.24;

contract ZombieSurvival {
    //Struct to hold the information of a player
    struct Player {
        address owner;
        uint health;
        uint ammo;
        uint score;
        mapping(string => uint) inventory;
        mapping(string => uint) upgrades;
    }

    //Mapping to hold all the players
    mapping(address => Player) public players;

    //Event to be emitted when player shoots a zombies
    event Shoot(address shooter);
    //Event to be emitted when player's health changes
    event HealthChanged(address player, uint newHealth);
    //Event to be emitted when player's score changes
    event ScoreChanged(address player, uint newScore);

    //Function to join the game
    function joinGame() public {
        require(players[msg.sender].owner == address(0));
        players[msg.sender].owner = msg.sender;
        players[msg.sender].health = 100;
        players[msg.sender].ammo = 20;
        players[msg.sender].score = 0;
    }

    //Function to shoot a zombies
    function shoot() public {
        require(players[msg.sender].health > 0);
        require(players[msg.sender].ammo > 0);
        //decrement ammo
        players[msg.sender].ammo--;
        //increment score
        players[msg.sender].score++;
        //check if the player hit a zombies
        if (checkHit()) {
            //decrement health
            players[msg.sender].health -= 10;
            emit HealthChanged(msg.sender, players[msg.sender].health);
            checkDeath();
        }
        emit ScoreChanged(msg.sender, players[msg.sender].score);
        emit Shoot(msg.sender);
    }

    //Function to acquire an item
    function acquireItem(string _itemName) public {
        require(players[msg.sender].score >= getItemCost(_itemName));
        require(players[msg.sender].inventory[_itemName] == 0);
        players[msg.sender].score -= getItemCost(_itemName);
        players[msg.sender].inventory[_itemName]++;
    }
    //Function to upgrade a weapon
    function upgradeWeapon(string _weaponName) public {
        require(players[msg.sender].score >= getWeaponUpgradeCost(_weaponName));
        uint currentLevel = getWeaponLevel(msg.sender, _weaponName);
        require(currentLevel != 0);
        require(currentLevel < maxWeaponLevel);
        players[msg.sender].score -= getWeaponUpgradeCost(_weaponName);
        players[msg.sender].upgrades[_weaponName]++;
    }
    //Function to complete a quest
    function completeQuest(string _questName) public {
        require(players[msg.sender].health > 0);
        require(players[msg.sender].ammo > 0);
        //check if the player completed the quest
        if (checkQuestCompletion(_questName)) {
            //increment score
            players[msg.sender].score += getQuestReward(_questName);
            //increment health
            players[msg.sender].health += getQuestHealthReward(_questName);
            //increment ammo
            players[msg.sender].ammo += getQuestAmmoReward(_questName);
        }
    }
    //Function to buy TRX from the shop
    function buyTRX(uint _amount) public {
        require(msg.sender.transfer(_amount));
    }
    //Function to sell TRX to the shop
    function sellTRX(uint _amount) public payable {
        require(msg.value == _amount);
    }
    //Function to check if the player completed a quest
    function checkQuestCompletion(string _questName) private view returns (bool) {
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 2;
        if (random == 1) return true;
        else return false;
    }
    //Function to get the cost of an item
    function getItemCost(string _itemName) public view returns (uint) {
        if (_itemName == "medkit") return 1000;
        if (_itemName == "ammo_box") return 5000;
        if (_itemName == "first_aid_kit") return 10000;
    }
    //Function to get the cost of upgrading a weapon
    function getWeaponUpgradeCost(string _weaponName) public view returns (uint) {
        if (_weaponName == "pistol") return 500;
        if (_weaponName == "shotgun") return 2500;
        if (_weaponName == "rifle") return 5000;
    }
    //Function to get the reward of a quest
    function getQuestReward(string _questName) public view returns (uint) {
        if (_questName == "survival") return 100;
        if (_questName == "zombie_hunt") return 250;
        if (_questName == "rescue_mission") return 500;
    }
    //Function to get the health reward of a quest
    function getQuestHealthReward(string _questName) public view returns (uint) {
        if (_questName == "survival") return 10;
        if (_questName == "zombie_hunt") return 25;
        if (_questName == "rescue_mission") return 50;
    }
    //Function to get the ammo reward of a quest
    function getQuestAmmoReward(string _questName) public view returns (uint) {
        if (_questName == "survival") return 5;
        if (_questName == "zombie_hunt") return 10;
        if (_questName == "rescue_mission") return 20;
    }
    //Function to get the current level of a weapon
    function getWeaponLevel(address _owner, string _weaponName) public view returns (uint) {
        return players[_owner].upgrades[_weaponName];
    }
    //Function to login and get a daily reward
    function login() public {
        require(players[msg.sender].health > 0);
        require(players[msg.sender].ammo > 0);
        //increment score
        players[msg.sender].score += 10;
        //increment health
        players[msg.sender].health += 5;
        //increment ammo
        players[msg.sender].ammo += 2;
    }
    //Function to save the game progress
    function saveProgress() public {
        //Save the player's data to storage or IPFS
    }
    //Function to load the game progress
    function loadProgress() public view returns (bool) {
        //Load the player's data from storage or IPFS
        //if the data is successfully loaded return true, else return false
    }
    //Function to trade with another player
    function trade(address _otherPlayer, string _itemName, uint _amount) public {
        require(players[msg.sender].inventory[_itemName] >= _amount);
        require(players[_otherPlayer].inventory[_itemName] >= _amount);
        players[msg.sender].inventory[_itemName] -= _amount;
        players[_otherPlayer].inventory[_itemName] += _amount;
    }
}