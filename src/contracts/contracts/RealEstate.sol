// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract RealEstate  is ERC721URIStorage {

     constructor() ERC721("NFTMarketplace", "NFTM") {
        owner = payable(msg.sender);
    }


    address owner = msg.sender;

    using Counters  for Counters.Counter;
    Counters.Counter private tokenid;
    Counters.Counter private itemsold;

    struct ListedItem {
        uint tokenid;
        uint price;
        address buyer;
        address owner;
        bool listed;
    }

    mapping (uint=> ListedItem ) idtoprop ;
    

    function createNFT(string memory tokenURI , uint price)  public payable returns (uint256){

    
    uint newtokenid = tokenid.current();
    
    tokenid.increment();


    _safeMint(msg.sender , newtokenid);

    _setTokenURI(newtokenid , tokenURI);

    listNFT(newTokenId, price);
      
    }

    return newtokenid ;

    }


    function listNFT(uint256 _tokenid , uint price ) public {
        

        require(price<0 ,"Amount should be more than 0");
        require(msg.sender==owner,"Only owner can list ");

        idtoprop[_tokenid] = ListedItem(
            _tokenid,
            price,
            payable(msg.sender),
            payable(address(this)),
            true
            
            );

    }



    function FetchAllNft()public view returns(ListedItem[] memory)   {
        uint totalcount = tokenid.current();
        ListedItem[]  memory tokens = new ListedItem[](totalcount);
        uint currentid ; 
        
        for(uint i=0;i<totalcount;i++){
            
            currentid = i+1;

            ListedItem storage currentitem = idtoprop[currentid];
            tokens[i] = currentitem ;
        
        }

        return tokens ;
    }



    function FetchMYNFT() public view returns(ListedItem[] memory )    {
        uint totalcount = tokenid.current();
        ListedItem[]  memory mynft = new ListedItem[](totalcount);
        uint currentid ; 
        
        for( uint i=0;i<totalcount;i++){
            
            currentid = i+1;

            ListedItem storage myitems = idtoprop[currentid];
            

            if( idtoprop[i+1].owner == msg.sender)
                
                
                {
                    mynft[i] = myitems ;

            }
            
        
        }

        return mynft ;
    }



        

        



    


    function sale(uint _tokenid) payable public{
        uint price = idtoprop[_tokenid].price;
        address seller = idtoprop[_tokenid].owner;

        require(msg.value==price,"Please pay the asked amount");


        idtoprop[_tokenid].listed = true ;
        idtoprop[_tokenid].owner= payable(msg.sender);
        itemsold.increment();

        _transfer(idtoprop[_tokenid].owner , msg.sender , _tokenid);


        approve(address(this), _tokenid);
        
    }


}

