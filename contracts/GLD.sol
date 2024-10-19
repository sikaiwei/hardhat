// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract GLD is ERC20 {
    constructor(uint256 initial) ERC20("Gold", "GLD") {
        console.log("Deploying GLD", msg.sender, initial);
        _mint(msg.sender, initial);
    }
    // approve
    function approve(address spender, uint256 amount) public override returns (bool) {
        console.log("Approve", msg.sender, spender, amount);
        return super.approve(spender, amount);
    }
    // transferFrom
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        console.log("TransferFrom", sender, recipient, amount);
        return super.transferFrom(sender, recipient, amount);
    }

    
    // 候选人结构体  
    struct Candidate {  
        string name;  
        uint256 voteCount;  
    }  
  
    // 投票者结构体  
    struct Voter {  
        bool hasVoted;  
        uint256 votedCandidateId;  
    }  
  
    // 候选人数组  
    Candidate[] public candidates;  
    // 投票者映射  
    mapping(address => Voter) public voters;  
  
    // 事件  
    event CandidateAdded(uint256 indexed candidateId, string name);  
    event VoteCasted(address indexed voter, uint256 indexed candidateId);  
  
    // 添加候选人  
    function addCandidate(string memory name) public {  
        Candidate memory newCandidate = Candidate({  
            name: name,  
            voteCount: 0  
        });  
        candidates.push(newCandidate);  
        emit CandidateAdded(candidates.length - 1, name);  
    }  

    // 添加投票者（在这个例子中，任何调用投票函数的人都会自动成为投票者）  
    // 这个函数实际上不需要显式调用，因为投票时会检查投票者状态  
  
    // 投票  
    function vote(uint256 candidateId) public {  
        require(candidateId < candidates.length, "Candidate ID out of range");  
        require(!voters[msg.sender].hasVoted, "Already voted");  
  
        voters[msg.sender] = Voter({  
            hasVoted: true,  
            votedCandidateId: candidateId  
        });  
  
        candidates[candidateId].voteCount++;  
  
        emit VoteCasted(msg.sender, candidateId);  
    }  
    // 查询投票结果  
    function getVoteCount(uint256 candidateId) public view returns (uint256) {  
        require(candidateId < candidates.length, "Candidate ID out of range");  
        return candidates[candidateId].voteCount;  
    }  
  
    // 查询所有候选人及其票数  
    function getAllCandidates() public view returns (Candidate[] memory) {  
        return candidates;  
    }  

}
