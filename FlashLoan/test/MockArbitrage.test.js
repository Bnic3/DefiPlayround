const MockArbitrage = artifacts.require("MockArbitrage");
const TestToken= artifacts.require("TestToken")

contract("MockArbitrage",()=>{
  it("Should own 1000 testtoken supply", async()=>{
    const mockArbitrageInstance=  await MockArbitrage.deployed();
    const testTokenInstance = await TestToken.deployed();    
    const mockTokenBalance = (await testTokenInstance.balanceOf.call(mockArbitrageInstance.address)).toNumber();
    assert.equal(mockTokenBalance,1000)

  })
})