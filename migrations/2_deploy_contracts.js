let CrowdFunding = artifacts.require("./CrowdFunding.sol");

module.exports = function(deployer) {
  deployer.deploy(CrowdFunding).then(() => console.log(CrowdFunding.address))
};