const TempolandContract = artifacts.require("TempolandContract");

module.exports = function (deployer) {
  deployer.deploy(TempolandContract);
};
