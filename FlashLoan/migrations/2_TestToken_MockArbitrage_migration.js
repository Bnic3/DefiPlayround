const TestToken = artifacts.require("TestToken");
const MockArbitrage = artifacts.require("MockArbitrage");

module.exports = function (deployer) {
  deployer.deploy(MockArbitrage).then(()=> deployer.deploy(TestToken,1000,MockArbitrage.address))  
};
