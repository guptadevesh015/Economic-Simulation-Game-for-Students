// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EconomicSimulationGame {

    string public name = "EconomicSimulationGame";
    string public symbol = "ESG";
    uint8 public decimals = 18;
    uint256 public initialBalance = 1000 * 10**18; // 1000 tokens with 18 decimal points

    mapping(address => uint256) public balances;
    mapping(address => bool) public registeredPlayers;

    address public owner;

    event Registered(address player);
    event Transaction(address player, uint256 amount, string action);
    event RewardClaimed(address player, uint256 rewardAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    modifier isRegistered() {
        require(registeredPlayers[msg.sender], "You need to register first.");
        _;
    }

    constructor() {
        owner = msg.sender; // Assign the contract creator as the owner
    }

    function register() public {
        require(!registeredPlayers[msg.sender], "You are already registered.");
        
        // Register player and give them initial balance
        registeredPlayers[msg.sender] = true;
        balances[msg.sender] = initialBalance;

        emit Registered(msg.sender);
    }

    function getBalance() public view isRegistered returns (uint256) {
        return balances[msg.sender];
    }

    function invest(uint256 amount) public isRegistered {
        require(balances[msg.sender] >= amount, "Insufficient balance to invest.");
        
        // Decrease the player's balance and simulate an investment
        balances[msg.sender] -= amount;

        // Here you can add logic to simulate the investment outcomes, like earning rewards.
        emit Transaction(msg.sender, amount, "Invested");
    }

    function claimReward(uint256 rewardAmount) public isRegistered {
        // Add reward to the player's balance
        balances[msg.sender] += rewardAmount;
        emit RewardClaimed(msg.sender, rewardAmount);
    }

    function transfer(address recipient, uint256 amount) public isRegistered {
        require(balances[msg.sender] >= amount, "Insufficient balance to transfer.");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transaction(msg.sender, amount, "Transferred");
    }

    function ownerWithdraw(uint256 amount) public onlyOwner {
        // Allow owner to withdraw tokens (can be used for game fund or other features)
        payable(owner).transfer(amount);
    }

    receive() external payable {}
}
