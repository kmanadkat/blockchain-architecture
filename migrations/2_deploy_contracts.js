// const ExerciseC6A = artifacts.require("ExerciseC6A");
const ExerciseC6AMultiParty = artifacts.require("ExerciseC6AMultiParty");

module.exports = function(deployer) {

    // deployer.deploy(ExerciseC6A);
    deployer.deploy(ExerciseC6AMultiParty);

}