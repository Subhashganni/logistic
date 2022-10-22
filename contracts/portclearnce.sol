// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;
import "./logistic.sol";

contract clearence{  
    Forwarder f;
    
    uint Expcount=1;
    struct export{

       uint expId;
       bool cleared;
       address forwarderAddr;
       address seller; 
    }

    uint Impcount=1;
    struct Import{
        uint expId;
        bool cleared;
        address forwarderAddr;
        address seller; 
    }
    
    mapping (uint => export) public  expClearence;
    mapping (uint => Import) public  impClearence;

    address portAddr;
    //address imptAddr;

    constructor (address portC) {
          portAddr = portC;
          //imptAddr = imp;
    }

    // modifier onlyExp() {
    //     require(msg.sender==exportAddr, "Not a export address");
    //     _;
    // }

    // modifier onlyImp() {
    //     require(msg.sender==imptAddr, "Not a import address");
    //     _;
    // }
    
    

    function exportClearence(uint eid,address  _forworder,address _seller) external  returns(bool) {
        require(expClearence[Expcount].cleared == false, "Already cleared");
         expClearence[Expcount]= export(eid,true,_forworder,_seller);
         return expClearence[Expcount].cleared;

    }

    function importClearence(uint eid,address  _forworder,address _seller) external   returns(bool) {
        require(impClearence[Impcount].cleared == false, "Already cleared");
         impClearence[Impcount]= Import(eid,true,_forworder,_seller);
         return impClearence[Impcount].cleared;
    }

    

  
          
    
}