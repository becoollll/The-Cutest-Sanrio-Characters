// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    address public owner;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount; //候選人數量
    uint public totalVotes; //總投票數

    event Voted(address indexed voter, uint indexed candidateId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalVotes = 0;
        addCandidate("POMPOMPURIN");
        addCandidate("BAD BADTZ-MARU");
        addCandidate("POCHACCO");
        addCandidate("HANGYODON");
        addCandidate("MY MELODY");
        addCandidate("CINNAMOROLL");
    }

    function addCandidate(string memory name) private onlyOwner { //確保只有Owner才可以新增候選人
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, name, 0);
    }

    function vote(uint candidateId) public {
        require(candidateId > 0 && candidateId <= candidatesCount, "Invalid candidate ID."); //輸入不存在的id時, metamask會無法估算gas, 也就無法投票

        candidates[candidateId].voteCount++;
        totalVotes++;

        emit Voted(msg.sender, candidateId); //event
    }

    function getTotalVotes() public view returns (uint) {
        return totalVotes;
    }

    function getFirst() public view returns (uint, string memory, uint) {
        uint firstVotes = 0;
        uint firstId = 0;

        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > firstVotes) {
                firstVotes = candidates[i].voteCount;
                firstId = i;
            }
        }

        Candidate memory firstCandidate = candidates[firstId];
        return (firstCandidate.id, firstCandidate.name, firstCandidate.voteCount);
    }

    function getSecond() public view returns (uint, string memory, uint) {
        uint firstVotes = 0;
        uint secondVotes = 0;
        uint firstId = 0;
        uint secondId = 0;

        for (uint i = 1; i <= candidatesCount; i++) {
            uint voteCount = candidates[i].voteCount;
            if (voteCount > firstVotes) {
                secondVotes = firstVotes;
                secondId = firstId;
                firstVotes = voteCount;
                firstId = i;
            } else if (voteCount > secondVotes) {
                secondVotes = voteCount;
                secondId = i;
            }
        }

        Candidate memory secondCandidate = candidates[secondId];
        return (secondCandidate.id, secondCandidate.name, secondCandidate.voteCount);
    }



}
