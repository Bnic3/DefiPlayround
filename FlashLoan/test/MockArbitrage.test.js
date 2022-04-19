const MockArbitrage = artifacts.require("MockArbitrage");
const TestToken= artifacts.require("TestToken")
const FirstFlashLoan = artifacts.require("FirstFlashLoan");

contract("MockArbitrage",(accounts)=>{
  it("Should own 1000 testtoken supply", async()=>{
     const mockArbitrageInstance=  await MockArbitrage.deployed();
    const testTokenInstance = await TestToken.deployed();    
     const mockTokenBalance = (await testTokenInstance.balanceOf(mockArbitrageInstance.address)).toNumber();
    assert.equal(mockTokenBalance,1000)
    

  })

  it("should have all tokens withdrawable by owner", async()=>{
    const mockArbitrageInstance =  await MockArbitrage.deployed();
    const mockOwner = await mockArbitrageInstance.owner(); 
    const testTokenInstance = await TestToken.deployed(); 
    const oldTokenBalance = (await testTokenInstance.balanceOf(accounts[0])).toNumber();

    await mockArbitrageInstance.withdraw(testTokenInstance.address);    
    
    const newTokenBalance = (await testTokenInstance.balanceOf(accounts[0])).toNumber();

    assert.equal(accounts[0],mockOwner);
    assert.equal(oldTokenBalance,0);
    assert.equal(newTokenBalance,1000);

  })
})