// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.15;

contract OptimizedVote {
    struct Voter {
        uint8 vote;
        bool voted;
    }

    struct Proposal {
        uint8 voteCount;
        bool ended;
        bytes32 name;
    }

    Proposal[] proposals;

    mapping(address => Voter) public voters;

    function createProposal(bytes32 _name) external {
        proposals.push(Proposal({voteCount: 0, ended: false, name: _name}));
    }

    function vote(uint8 _proposal) external {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, 'already voted');
        sender.vote = _proposal;
        sender.voted = true;
        proposals[_proposal].voteCount++;
    }

    function getVoteCount(uint8 _proposal) external view returns (uint8) {
        return proposals[_proposal].voteCount;
    }
}
