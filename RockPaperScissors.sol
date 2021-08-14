// Copyright (C) 2021 Michal Drozd
// All Rights Reserved

pragma solidity ^0.4.24;

contract RockPaperScissors {
    // Enum to represent the game choices
    enum Choice { Rock, Paper, Scissors }

    // Event to be emitted on game result
    event Result(address player, Choice playerChoice, Choice houseChoice, bool playerWins);

    // Function to play the game
    function play(Choice _playerChoice) public payable {
        // Check if the player has enough TRX to play the game
        require(msg.value >= 1000000);

        // Generate a random number for the house choice
        uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 3;
        Choice houseChoice = Choice(random);

        // Determine the game result
        bool playerWins;
        if (_playerChoice == Choice.Rock && houseChoice == Choice.Scissors ||
        _playerChoice == Choice.Paper && houseChoice == Choice.Rock ||
            _playerChoice == Choice.Scissors && houseChoice == Choice.Paper) {
            playerWins = true;
        } else if (_playerChoice == houseChoice) {
            playerWins = false;
        } else {
            playerWins = false;
        }

        // Emit the Result event
        emit Result(msg.sender, _playerChoice, houseChoice, playerWins);

        // Send TRX to the player if they win
        if (playerWins) {
            msg.sender.transfer(msg.value * 2);
        }
    }
}