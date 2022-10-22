const Seller = artifacts.require("Seller");
const Buyer = artifacts.require("Buyer");
const Forwarder = artifacts.require("Forwarder");
//const { BN, constants,expectEvent, expectRevert } = require('@openzeppelin/test-helpers');

contract("Testing buyer contract ", (accounts) => {
    

  const addr = "0x0000000000000000000000000000000000000000";

  it("buyer is deployed and instance can be created", async () => {
    const buyerInstance = await Buyer.deployed();
    // const balance = await EvenStoreInstance.getBalance.call(accounts[0]);

    assert.notEqual(buyerInstance, null, "buyer instance could not be created");
  });

  it("buyer choose seller", async () => {
    const buyerInstance = await Buyer.deployed();

     const owner = await buyerInstance.chooseSeller.call("0x2e6B07e9cacf366DdB8Ee2714f536F953bAA7103");
     

    assert.notEqual(owner,addr, "seller not be null address");
  });

  it("buyer choose Freighter", async () => {
    const buyerInstance = await Buyer.deployed();

     const owner = await buyerInstance.chooseFreight.call("0xD721D051Ae5910b46258B98d768330103E861EdB");

    assert.notEqual(owner,addr , "Enter valid  address");
  });




//   it("Check for choose", async () => {
//     const sellerInstance = await Seller.deployed();
//     const owner = await sellerInstance.seller.call();

//     assert.equal(owner, seller, "seller instance could not be created");
//   });



});

contract("Testing seller contract ", (accounts) => {

  const addr = "0x0000000000000000000000000000000000000000";


    it("Seller is deployed and instance can be created", async () => {
      const sellerInstance = await Seller.deployed();
      assert.notEqual(sellerInstance, null, "seller instance could not be created");
    });

    it("seller choose Freighter", async () => {
      const sellerInstance = await Seller.deployed();
  
       const owner = await sellerInstance.chooseFreight.call("0xD721D051Ae5910b46258B98d768330103E861EdB");
  
      assert.notEqual(owner,addr , "Enter valid  address");
    });
  
    
  });

contract("Testing Forwarder contract ", (accounts) => {

  const addr = "0x0000000000000000000000000000000000000000";

     it("Forwarder is deployed and instance can be created", async () => {
    const ForwarderInstance = await Forwarder.deployed();

    assert.notEqual(ForwarderInstance, null, "Enter valid address");

    });

    it("Forwarder is deployed and instance can be created", async () => {
      const ForwarderInstance = await Forwarder.deployed();
      const owner = await ForwarderInstance.chooseClearence.call("0x18BadbEBBf4aE05579d82104C9DAb9C90276Ae0f");
      assert.notEqual(ForwarderInstance, addr, "Enter valid addres");
  
      });
  
    
  });