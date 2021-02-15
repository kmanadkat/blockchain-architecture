var Test = require('../config/testConfig.js');

contract('ExerciseC6AMultiParty', async (accounts) => {
  var config;
  before('setup contract', async () => {
    config = await Test.Config(accounts);
  });

  it('contract owner can register new user', async () => {

    // ARRANGE
    let caller = accounts[0]; // This should be config.owner or accounts[0] for registering a new user
    let newUser = config.testAddresses[0]; 

    // ACT
    await config.ExerciseC6AMultiParty.registerUser(newUser, false, {from: caller});
    let result = await config.ExerciseC6AMultiParty.isUserRegistered.call(newUser); 

    // ASSERT
    assert.equal(result, true, "Contract owner cannot register new user");

  });

  it('function call is made when multi-party threshold is reached', async () => {

    // ARRANGE
    let admin1 = accounts[1];
    let admin2 = accounts[2];
    let admin3 = accounts[3];

    await config.ExerciseC6AMultiParty.registerUser(admin1, true, {from: config.owner});
    await config.ExerciseC6AMultiParty.registerUser(admin2, true, {from: config.owner});
    await config.ExerciseC6AMultiParty.registerUser(admin3, true, {from: config.owner});
    
    let initialStatus = await config.ExerciseC6AMultiParty.isOperational.call();
    let changedStatus = !initialStatus;

    // ACT
    await config.ExerciseC6AMultiParty.setOperatingStatus(changedStatus, {from: admin1});
    await config.ExerciseC6AMultiParty.setOperatingStatus(changedStatus, {from: admin2});

    let newStatus = await config.ExerciseC6AMultiParty.isOperational.call();

    // ASSERT
    assert.equal(changedStatus, newStatus, "Multi-party call failed");
  });
});
