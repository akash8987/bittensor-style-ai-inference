// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AIEngine
 * @dev Manages registration of AI Miners and Validators.
 */
contract AIEngine is Ownable {
    struct Neuron {
        address addr;
        uint256 stake;
        uint256 lastUpdate;
        bool isValidator;
    }

    mapping(address => Neuron) public neurons;
    address[] public neuronAddresses;

    event NeuronRegistered(address indexed neuron, bool isValidator);

    constructor() Ownable(msg.sender) {}

    function register(bool _isValidator) external payable {
        require(msg.value >= 0.1 ether, "Minimum stake required");
        
        neurons[msg.sender] = Neuron({
            addr: msg.sender,
            stake: msg.value,
            lastUpdate: block.timestamp,
            isValidator: _isValidator
        });
        
        neuronAddresses.push(msg.sender);
        emit NeuronRegistered(msg.sender, _isValidator);
    }

    function getNeuronCount() external view returns (uint256) {
        return neuronAddresses.length;
    }
}
