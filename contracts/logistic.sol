// SPDX-License-Identifier: MIT
import "./buyer.sol";
import "./seller.sol";
import "./portclearnce.sol";

pragma solidity ^0.8.16;

contract Forwarder{

    Buyer b;
    Seller s;
    clearence c;
    address logisticAddr;
    uint oid;

    struct FreightBook{
        uint oid;
        string  bname;
        uint bnum;
        uint bpincode;
        bool booked;
    }

    uint exportCount=1;

    struct pickD{
        //uint id;
        uint exportId;
        address seller;
        string buyer;
        uint buyerPinCode;
        bool picked;
        bool exportC;
        bool importC;
        
        bool delivertStarted;
        bool delivered;
    }

    mapping (uint => FreightBook) public FreightBooking;
    uint charges = 1000000000000000000;
    mapping (uint => pickD) public pickups;
    
    constructor (address _addr){
        logisticAddr = _addr;
    }

    modifier onlyFreighter() {
        require(msg.sender==logisticAddr, "Not a Freighter");
        _;
    }

    function chooseClearence(address addrs) public returns(address) {
        
        c = clearence(addrs);
        return addrs;
    }

   

    function bookFreight(uint oid,address _seller) external returns(uint,address) {
       require(FreightBooking[oid].booked == false, "Already booked");
       s = Seller(_seller);


       (uint _oid,string memory bname, uint _bnum,uint _pincode) = s.giveDetails(oid);
       
       FreightBooking[oid].oid=_oid;
       FreightBooking[oid].bname = bname;
       FreightBooking[oid].bnum = _bnum;
       FreightBooking[oid].bpincode = _pincode;
       FreightBooking[oid].booked = true;
       
       return (charges,logisticAddr);

    }

    function viewBooking (uint oid) public view returns(FreightBook memory){
         return FreightBooking[oid];
    }

    uint newoid;
    
    function pickup(uint oid) public onlyFreighter{
       //pickups[oid].id  
       require(FreightBooking[oid].booked == true, "Freighter not booked");

       (uint _oid,address _s,string memory _badr,uint _pincode) = s.pickup(oid);
        newoid = _oid;
       pickups[exportCount] = pickD(exportCount,_s,_badr,_pincode,true,false,false,false,false);
       exportCount += 1;
    }

    function viewPickupDetails(uint id) public view  returns(pickD memory) {
        return pickups[id];
    }

    
   function startDelivery(uint _expoID) public onlyFreighter {
       require(pickups[_expoID].delivertStarted == false, "Already started");

        pickups[_expoID].delivertStarted = true;
 
    }

    function Delivery(uint _expoID) public onlyFreighter {
        require(pickups[_expoID].exportC == true, "export clearence needed");
        require(pickups[_expoID].importC == true, "Import clearence nedded");
        require(pickups[_expoID].delivered == false, "Already delivered");
 
        pickups[_expoID].delivered = true;
 
    }
}