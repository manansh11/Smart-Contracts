pragma solidity ^0.6.6;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";

contract Allowance is Ownable {
    
    using SafeMath for uint;
    
    //Allows us to see data in the log once a transaction has occoured
    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount);
    
    mapping(address => uint) public allowance;
    
    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }
      //Modifer to determine if person trying to transact is the owner or has more money in their account than what they are trying to withdraw
    modifier ownerOrAllowed(uint _amount) {
        require(msg.sender == owner() || allowance[msg.sender] >= _amount, "Not allowed");
        _;
    }
    
    //Goes to the mapping of the address and subtracts the amount from their allowance
    //Internal keyword is used for functions that need to be kept internally and not visible to public
    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
        allowance[_who] = allowance[_who].sub(_amount);
    }
}

contract SimpleWallet is Allowance {
    
    event MoneySent(address _beneficiary, uint _amount);
    event MoneyRecieved(address indexed _from, uint _amount);
    
    //Allow smart contract to recieve funds
    receive() external payable {
        emit MoneyRecieved(msg.sender, msg.value);
    }
    
    
    
    //Renounce function in the OpenZeppelin contract that allows us to give up ownership
    //We use 'override' keyword to do this
    function renounceOwnership() public override onlyOwner {
        revert("Can't renounce ownership sorry");
    }
    
    
    //Can send money from smart contract to certan address
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "There is no money in this smart contract");
        if(!(msg.sender == owner())) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    
    
}
