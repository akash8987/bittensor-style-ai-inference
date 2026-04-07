// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AIEngine.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title IncentiveLayer
 * @dev Distributes rewards based on validator scores.
 */
contract IncentiveLayer is ERC20, Ownable {
    AIEngine public aiEngine;
    
    mapping(address => uint256) public scores;

    constructor(address _aiEngine) ERC20("AI Reward", "AIR") Ownable(msg.sender) {
        aiEngine = AIEngine(_aiEngine);
    }

    /**
     * @dev Validators submit scores for miners. 
     * In production, this uses a Yuma Consensus style weight aggregation.
     */
    function submitScores(address[] calldata _miners, uint256[] calldata _values) external {
        require(aiEngine.neurons(msg.sender).isValidator, "Only validators");
        require(_miners.length == _values.length, "Mismatched arrays");

        for (uint i = 0; i < _miners.length; i++) {
            scores[_miners[i]] += _values[i];
            _mint(_miners[i], _values[i] * 1e18); // Reward minting
        }
    }
}
