pragma solidity ^0.4.25;

contract ExerciseC6AMultiParty {
    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    uint constant requiredNumberForConsensus = 2;
    struct UserProfile {
        bool isRegistered;
        bool isAdmin;
    }

    address private contractOwner; // Account used to deploy contract
    mapping(address => UserProfile) userProfiles; // Mapping for storing user profiles
    bool public isOperational;

    address [] multiCalls = new address[](0);

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    // No events

    /**
     * @dev Constructor
     *      The deploying account becomes contractOwner
     *      The contract is set to operational
     */
    constructor() public {
        contractOwner = msg.sender;
        isOperational = true;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
     * @dev Modifier that requires the "ContractOwner" account to be the function caller
     */
    modifier requireContractOwner() {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    /**
     * @dev Modifier that requires the "ContractAdmin" account to be the function caller
     */
    modifier requireContractAdmin() {
        require(userProfiles[msg.sender].isAdmin == true, "Caller is not contract owner");
        _;
    }

    /**
     * @dev Modifier that requires the contract to be operational for function to execute
     */
    modifier requireIsOperational() {
        require(isOperational, "Contract is not operational");
        _;
    }


    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
     * @dev Check if a user is registered
     *
     * @return A bool that indicates if the user is registered
     */

    function isUserRegistered(address account) external view returns (bool) {
        require(account != address(0), "'account' must be a valid address.");
        return userProfiles[account].isRegistered;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function registerUser(address account, bool isAdmin)
        external
        requireContractOwner
        requireIsOperational
    {
        require(
            !userProfiles[account].isRegistered,
            "User is already registered."
        );

        userProfiles[account] = UserProfile({
            isRegistered: true,
            isAdmin: isAdmin
        });
    }

    function setOperatingStatus(bool mode) external requireContractAdmin {
        require(mode != isOperational, 'New mode must be different from existing mode');
        require(userProfiles[msg.sender].isAdmin, 'Caller is not an admin');

        bool isDuplicate = false;
        for (uint i = 0; i < multiCalls.length; i++) {
            if(multiCalls[i] == msg.sender){
                isDuplicate = true;
                break;
            }
        }

        require(!isDuplicate, 'Caller has already called the function');

        multiCalls.push(msg.sender);
        if(multiCalls.length >= requiredNumberForConsensus) {
            isOperational = mode;
            multiCalls = new address[](0);
        }
    }
}
