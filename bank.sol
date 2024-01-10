// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Bank {
    address public owner;

    mapping(address => uint256) private balances;

    address[3] private top3Adresses;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
        updateTop3();
    }

    function updateTop3() private {
        uint8 insertIndex;

        for (insertIndex = 0; insertIndex < 3; insertIndex++) {
            if (balances[msg.sender] > balances[top3Adresses[insertIndex]]) {
                break;
            }
        }

        if (insertIndex != 3) {
            for (uint8 i = 2; i > insertIndex; i--) {
                top3Adresses[i] = top3Adresses[i - 1];
            }

            top3Adresses[insertIndex] = msg.sender;
        }
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Bank balance is zero.");
        payable(msg.sender).transfer(address(this).balance);
    }

    function getBalance(address x) public view returns (uint256) {
        return balances[x];
    }

    function getTop3() public view returns (address[3] memory) {
        return top3Adresses;
    }
}
