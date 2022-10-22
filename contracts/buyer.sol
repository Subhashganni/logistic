// SPDX-License-Identifier: MIT

import "./seller.sol";
import "./logistic.sol";

pragma solidity ^0.8.16;

contract Buyer{

    // Seller s;
    Seller s;
    address buyerAddr;
    Forwarder f;

    struct buyer{
        uint buyerID;
        string name;
        uint40 num;
        string addr;
        uint pincode;
        
    }
    

    uint regId;
    mapping (uint => buyer) public Buyers;

    constructor(){
         buyerAddr= msg.sender;
    }

    modifier onlyBuyer() {
        require(msg.sender==buyerAddr, "Not buyer");
        _;
    }
    
    address seller;

    function chooseSeller(address _seller) public returns(address) 
     {
         seller = _seller;
         s = Seller(_seller);
         return seller;
    }

    function chooseFreight(address _addrs) public returns(address) {
        
        f = Forwarder(_addrs);
        return _addrs;
    }

    function register(uint id , string memory _name,uint40  _num,string memory addrs,uint _pin) public  {
          regId += 1;
          Buyers[regId] = buyer(id,_name,_num,addrs,_pin);
    }

    function requestProduct(uint PID) public  returns ( string memory, string memory, uint,bool,address){
        
        address _buyer = msg.sender;
        return s.requestProductQuotes(PID,_buyer);
    }

    function Buy(uint PID,uint rId) public payable  {
    
       address _buyer = msg.sender;
       //uint bid = Buyers[regId].buyerID;
       string memory _name = Buyers[rId].name;
       uint bnum = Buyers[rId].num;
       string memory bAdrs = Buyers[rId].addr;
       uint _pin  = Buyers[rId].pincode;
       
      (uint price,address _seller) = s.order(PID,_buyer,_name,bnum,bAdrs,_pin);

       require(msg.value == price, "can't afford");
       (bool status, ) = _seller.call{value: msg.value}("");
       require(status,"transaction failed");
       
 
    } 

    function bookFreight(uint oid) public payable  {
        //address seller = s.sendAddrs();
        (uint charge, address logisticAddr) = f.bookFreight(oid,seller);
       require(msg.value == charge, "insufficient fund");
       (bool status, ) = logisticAddr.call{value: msg.value}("");
       require(status,"transaction failed");

    }
    

}