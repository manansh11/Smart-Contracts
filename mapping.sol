
pragma solidity ^0.6.0;

contract MyContract{
    
    //Mappings 
    mapping(uint => string) public names;
    mapping(uint => Book) public books;
    
    
    //nested mapping
    mapping(address => mapping(uint => Book)) public myMapping;
    
        
    struct Book {
        string title;
        string author;
    }
    
    
    
     constructor() public {
         names[1] = "Atom";
         names[2] = "Bruce";
         names[3] = "Carl";
     }
     
     //regular mapping

    function addBook(uint _id, string memory _title, string memory _author) public {
        books[_id] = Book(_title, _author);
    }
    
    //Make use of nested mapping
    
    function addMyBook(uint _id, string memory _title, string memory _author) public {
        myMapping[msg.sender][_id] = Book(_title, _author);
    }
     
    
}
