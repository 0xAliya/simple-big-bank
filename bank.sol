// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Bank {
    address public owner;

    mapping(address => uint256) internal balances;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable virtual {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Bank balance is zero.");
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Withdraw call failed.");
    }
}

contract BigBank is Bank {
    modifier bigUserOnly() {
        require(msg.value >= 1 ether, "You need to deposit at least 1 ether.");
        _;
    }

    function deposit() public payable override bigUserOnly {
        balances[msg.sender] += msg.value;
    }

    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}

interface IBigBank {
    function withdraw() external;
}

contract Owner {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function withdraw(address _bigBank) public onlyOwner {
        IBigBank(_bigBank).withdraw();
        payable(msg.sender).transfer(address(this).balance);
    }
}
