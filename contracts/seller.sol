// SPDX-License-Identifier: MIT
import "./logistic.sol";
pragma solidity ^0.8.16;


contract Seller{
    Forwarder f;

    address seller;
    uint PID ;

    struct product{
        uint PID;
        string productName;
        string productDescription;
        uint productPrice;
        bool requested;
        bool orderProduct;
        address buyer;
        bool accepted;
    }
    uint oid=1;

    struct orderD{
        
        uint oid;
       
        string name;
        uint bnum;
        string  buyerAddrs;
        uint pincode;
        bool packed;
    }



   //uint pickupId=11;

   
   
    //mapping(uint => bool ) public packed;
    mapping (uint => product) public Products;
    mapping (uint => orderD) public orders;
    
    
    constructor(address _seller) {
        seller = _seller;
        
    }

    modifier onlySeller() {
        require(msg.sender == seller,"Not Seller");
        _;
    }

    function chooseFreight(address _addrs) public returns(address) {
        
        f = Forwarder(_addrs);
        return _addrs;
    }

    function order(uint _PID,address _buyerAddr,string memory bname,uint _bnum,string memory _addrs,uint _pincode) external  returns(uint,address)  {
        require(Products[_PID].accepted == true, "request not yet accepted");
        require(Products[_PID].orderProduct == false, "Already ordered");
        Products[_PID].orderProduct = true;
        Products[_PID].buyer = _buyerAddr;

       // orders[orderCount].oid = orderCount;
        orders[oid].oid=oid;
        orders[oid].name=bname;
        orders[oid].bnum=_bnum;
        orders[oid].buyerAddrs=_addrs;
        orders[oid].pincode=_pincode;
        orders[oid].packed=false;

        uint price = Products[_PID].productPrice;
        oid += 1;
        return (price,seller);

    }

    function addProduct(string memory _productName, string memory _productDescription, uint _productPrice) public onlySeller{
        PID +=1;
       // for(uint i=0;i<;)
        
        Products[PID] = product(PID,_productName,_productDescription,_productPrice,false,false,address(0x0),false);
        
    }

    function requestProductQuotes(uint _PID,address _buyerAddrs) external  returns ( string memory, string memory, uint,bool,address){
          
         // uint pID = Products[_PID].PID;
          Products[_PID].requested=true;
          string memory name = Products[_PID].productName;
          string memory description = Products[_PID].productDescription;
          uint price = Products[_PID].productPrice;
          bool ord = false;
          address bAddrs = _buyerAddrs;
          return (name,description,price,ord,bAddrs);
    }

    function packgoods(uint id) public onlySeller{
        require(Products[id].orderProduct == true, "Not ordered product");
        require(orders[id].packed == false, "Aleardy packed");
        orders[id].packed=true;
    }

    function giveDetails(uint oid) external view  returns(uint,string memory,uint,uint){
       require(orders[oid].packed == true, "need to pack the order");
       return (orders[oid].oid,orders[oid].name,orders[oid].bnum,orders[oid].pincode);
    }

    
    address sell = address(this);
    function pickup(uint id) external view returns(uint,address,string memory,uint) {
        require(orders[id].packed == true, "need to pack the order");
        
        return (orders[id].oid,sell,orders[id].buyerAddrs,orders[id].pincode);

    }

    function acceptRequest(uint pid) public onlySeller {
        require(Products[pid].requested==true, "Buyer not yet requested");
        require(Products[pid].accepted==false, "Aleardy accepted");
         Products[pid].accepted = true;
    }




}