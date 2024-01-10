// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Bank {
    address public owner;

    mapping(address => uint) public balances;

    address[3] public top3Adresses;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;

        if (top3Adresses.length < 3) {
            top3Adresses[top3Adresses.length] = msg.sender;
        } else {
            uint lowestIndex = 0;
            for (uint i = 1; i < 3; i++) {
                if (
                    balances[top3Adresses[i]] <
                    balances[top3Adresses[lowestIndex]]
                ) {
                    lowestIndex = i;
                }
            }
            if (balances[msg.sender] > balances[top3Adresses[lowestIndex]]) {
                top3Adresses[lowestIndex] = msg.sender;
            }
        }
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Bank balance is zero.");
        payable(msg.sender).transfer(address(this).balance);
    }

    function getBalance(address x) public view returns (uint) {
        return balances[x];
    }

    function getTop3() public view returns (address[3] memory) {
        return top3Adresses;
    }
}
