const TestToken = artifacts.require("TestToken");
const MockArbitrage = artifacts.require("MockArbitrage");
const FirstFlashLoan = artifacts.require("FirstFlashLoan");

module.exports = function (deployer) {
  deployer.deploy(MockArbitrage,10).then(()=> deployer.deploy(TestToken,1000,MockArbitrage.address))  
  //deployer.deploy(MockArbitrage,10).then(()=> deployer.deploy(FirstFlashLoan,MockArbitrage.address))  
};
