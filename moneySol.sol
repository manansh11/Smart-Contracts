pragma solidity ^0.7.0;

contract SendMoneyExample {
    
    uint public balanceRecieved;
    
    
    //Payable needs to be added on so that ether can be moved
    //Essentially allows anyone to send ether to the smart contract
    function recieveMoney() public payable {
        //msg.value is the amount that is being sent to the smart contract from the outside
        balanceRecieved += msg.value;
    }
    
    
    //View needs to be added on becasue we just want to read the value of the balance
    //We return an "this" with the type address and use ".balance" to read the smart contracts balance
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    
    
    function withdrawMoney() public {
        //msg.sender is the address that called the smart contract
        address payable to = msg.sender;
        
        //we can use ".transfer" to send money 
        to.transfer(this.getBalance());
    }
    
    
    // We don't need to set this function as payable because it is not recieving ether
    // You can specify which address to send ETH to like from below. Just use function params
    function withdrawMoneyTo(address payable _to) public {
        _to.transfer(this.getBalance());
    }
    
    
    
    
}
